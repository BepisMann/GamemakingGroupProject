extends StaticBody3D

@onready var area = get_node("../Area3D")
@onready var wall_mesh = $MeshInstance3D2
@export var move_speed: float = 1.2
var is_moving = false
var has_finished_moving = false
@export var target_position: Vector3 = Vector3(0, 0, 2.0)
var original_position: Vector3

@onready var moving_sound = $Moving_wall_sound

func _ready() -> void:
	original_position = transform.origin

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_moving and not has_finished_moving:
		transform.origin = transform.origin.move_toward(target_position, move_speed * delta)
		if transform.origin.distance_to(target_position) < 0.01:
			is_moving = false
			has_finished_moving = true
			moving_sound.stop()
	
	elif not is_moving and not has_finished_moving:
		transform.origin = transform.origin.move_toward(original_position, move_speed * delta)
		if transform.origin.distance_to(original_position) < 0.01:
			moving_sound.stop()



func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == "Player" and not has_finished_moving:
		if body.held_torch_count > 0:
			if moving_sound.is_playing():
				moving_sound.play()
			else: 
				moving_sound.play(0.19)
			is_moving = true


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.name == "Player" and not has_finished_moving:
		if body.held_torch_count > 0:
			moving_sound.play(0.19)
			is_moving = false
