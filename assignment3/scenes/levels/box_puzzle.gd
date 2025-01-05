extends Node3D

@export var rotation_duration: float = 1.0  # Duration of the rotation
@export var rotation_angle: float = PI / 2  # 90 degrees in radians

var is_rotating: bool = false
@onready var ball := $ball

func _ready():
	pass
	

func _input(event):
	if event.is_action_pressed("left") and not is_rotating:
		rotate_box(rotation.y-rotation_angle)
	elif event.is_action_pressed("right") and not is_rotating:
		rotate_box(rotation.y+rotation_angle)
		

func rotate_box(target_angle):
	if is_rotating:
		return
	is_rotating = true
	if ball and ball is RigidBody3D:
		ball.custom_integrator = true
	var rotate_tween := create_tween()
	rotate_tween.tween_property(self,"rotation:y", target_angle,rotation_duration)
	await rotate_tween.finished
	if ball and ball is RigidBody3D:
		ball.custom_integrator = false
	
	is_rotating = false


func _on_area_3d_area_exited(area):
	print ("box puzzle solved")
