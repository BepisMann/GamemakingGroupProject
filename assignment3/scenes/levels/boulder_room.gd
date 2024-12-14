extends Node3D

var wall_deleted = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_boulder_drop_area_body_entered(body: Node3D) -> void:
	if body.name == "Player" and !wall_deleted:
		wall_deleted = true
		$Hallway/Ceiling_Breakable.queue_free()
