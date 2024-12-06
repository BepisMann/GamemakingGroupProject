extends StaticBody3D

@onready var area = $Area3D
@onready var wall_mesh = $MeshInstance3D2
@export var move_speed: float = 1.2
var is_moving = false
@export var target_position: Vector3 = Vector3(0, 0, -5)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_moving:
		transform.origin = transform.origin.move_toward(target_position, move_speed * delta)
		if transform.origin.distance_to(target_position) < 0.01:
			is_moving = false



func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		if body.held_torch_count > 0:
			is_moving = true


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.name == "Player":
		if body.held_torch_count > 0:
			is_moving = false
