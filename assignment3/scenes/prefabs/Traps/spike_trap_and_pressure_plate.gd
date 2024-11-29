extends Node3D

@export
var is_deadly_spike: bool = false
@export
var is_deadly_pit: bool = false

var plate_deleted: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_spike_plate_detection_area_body_entered(body: Node3D) -> void:
	if is_deadly_spike && body.name == "Player":
		$"Prototype Spike trap".activate()
	if is_deadly_pit && body.name == "Player" && !plate_deleted:
		plate_deleted = true
		$Plate.queue_free()
