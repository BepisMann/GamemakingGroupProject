extends Node3D
signal bodyEnteredSpikes

@onready var spikes_sound = $"../../Spikes_sound"
@onready var pit_trap_sound = $"../../Pit_trap_sound"

@export
var is_deadly_spike: bool = false
@export
var is_deadly_pit: bool = false

var plate_deleted: bool = false


func _on_spike_detection_area_body_entered(body: Node3D) -> void:
	if is_deadly_spike && body.name == "Player":
		$"Prototype Spike trap".activate()
		spikes_sound.play()
		
func rearm():
	$Plate.show()
	$Plate/CollisionShape3D.set_deferred("disabled", false)
	plate_deleted = false
		
func _on_pit_detection_area_body_entered(body: Node3D) -> void:
	if is_deadly_pit && body.name == "Player" && !plate_deleted:
		$"../../../../Player".can_jump = false
		plate_deleted = true
		$Plate/CollisionShape3D.set_deferred("disabled", true)
		$Plate.hide()
		pit_trap_sound.play()

func _on_pit_spike_area_1_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		emit_signal("bodyEnteredSpikes")
		spikes_sound.play()


func _on_pit_spike_area_2_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		emit_signal("bodyEnteredSpikes")
		spikes_sound.play()


func _on_pit_spike_area_3_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		emit_signal("bodyEnteredSpikes")
		spikes_sound.play()


func _on_pit_spike_area_4_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		emit_signal("bodyEnteredSpikes")
		spikes_sound.play()


func _on_prototype_spike_trap_body_entered_ceiling_spikes() -> void:
	emit_signal("bodyEnteredSpikes")
	spikes_sound.play()
