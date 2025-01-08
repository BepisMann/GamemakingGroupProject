extends Node3D

signal playerDied

var wall_deleted = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_boulder_drop_area_body_entered(body: Node3D) -> void:
	if body.name == "Player" and !wall_deleted:
		body.set_spawn_point_2()
		wall_deleted = true
		$"Hallway/Ceiling_Breakable/AudioStreamPlayer3D".play()
		$Hallway/Ceiling_Breakable.queue_free()


func _on_boulder_player_crushed() -> void:
	emit_signal("playerDied")


func _on_trap_body_entered_spikes() -> void:
	emit_signal("playerDied")


func _on_audio_stream_player_3d_finished() -> void:
	queue_free()
