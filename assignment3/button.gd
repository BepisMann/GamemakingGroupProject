extends StaticBody3D

@export var move_distance: float = -0.05
@export var move_speed: float = 5.0
@onready var initial_position: Vector3 = Vector3.ZERO
var is_pressed: bool = false

@export var is_locked: bool = false

func _ready() -> void:
	initial_position = global_transform.origin

func _process(delta: float) -> void:
	if is_pressed:
		global_transform.origin = global_transform.origin.move_toward(initial_position - global_transform.basis.z * move_distance, move_speed * delta)
	else:
		global_transform.origin = global_transform.origin.move_toward(initial_position, move_speed * delta)

	



