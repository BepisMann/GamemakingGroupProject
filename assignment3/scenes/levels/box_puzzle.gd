extends Node3D

@export var rotation_duration: float = 1.0  # Duration of the rotation
@export var rotation_angle: float = PI / 2  # 90 degrees in radians

var solved: bool = false
var interactable: bool = false
var is_rotating: bool = false
@onready var ball := $ball

func _ready():
	pass
	
func _physics_process(delta):
	var max_speed = 2 # Maximum allowed speed
	var current_speed = ball.linear_velocity.length()
	if current_speed > max_speed:
		ball.linear_velocity = ball.linear_velocity.normalized() * max_speed

func _input(event):
	if not solved && interactable:
		if event.is_action_pressed("left") and not is_rotating:
			rotate_box(self.rotation.x-rotation_angle)
		elif event.is_action_pressed("right") and not is_rotating:
			rotate_box(self.rotation.x+rotation_angle)
		

func rotate_box(target_angle):
	if is_rotating:
		return
	is_rotating = true
	if ball and ball is RigidBody3D:
		ball.custom_integrator = true
	var rotate_tween := create_tween()
	rotate_tween.tween_property(self,"rotation_degrees:x", rad_to_deg(target_angle),rotation_duration)
	await rotate_tween.finished
	if ball and ball is RigidBody3D:
		ball.custom_integrator = false
	
	is_rotating = false

func interact():
	if interactable:
		interactable = false
	else:
		interactable = true
func _on_area_3d_body_exited(body: Node3D) -> void:
	solved = true
	print ("box puzzle solved")
