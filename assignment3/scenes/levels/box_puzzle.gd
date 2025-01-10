extends Node3D

@export var rotation_duration: float = 1.0  # Duration of the rotation
@export var rotation_angle: float = PI / 2  # 90 degrees in radians

var solved: bool = false
var interactable: bool = false
var is_rotating: bool = false
var check_speed: bool  = false
var player_is_interacting: bool = false
@onready var ball := $ball
@onready var speed_check_timer := $speedcheck
@onready var camera := $"../Camera3D"
@onready var letter := $"../Letter_of_code"
var player: CharacterBody3D

func _ready():
	pass
	
func _physics_process(delta):
	if check_speed and ball and ball is RigidBody3D:
		var max = 0.01
		if ball.linear_velocity.length()<max:
			is_rotating = false
			check_speed = false
	var max_speed = 2 # Maximum allowed speed
	if ball and ball is RigidBody3D:
		var current_speed = ball.linear_velocity.length()
		if current_speed > max_speed:
			ball.linear_velocity = ball.linear_velocity.normalized() * max_speed

func _input(event):
	if not solved && interactable:
		if event.is_action_pressed("left") and not is_rotating:
			rotate_box(self.rotation.y+rotation_angle)
		elif event.is_action_pressed("right") and not is_rotating:
			rotate_box(self.rotation.y-rotation_angle)
		

func rotate_box(target_angle):
	if is_rotating:
		return
	is_rotating = true
	if ball and ball is RigidBody3D:
		ball.custom_integrator = true
	var rotate_tween := create_tween()
	rotate_tween.tween_property(self,"rotation_degrees:y", rad_to_deg(target_angle),rotation_duration)
	$Rotating_box_puzzle_sound.play()
	await rotate_tween.finished
	if ball and ball is RigidBody3D:
		ball.custom_integrator = false
	speed_check_timer.start()

func interact(playernode):
	player = playernode
	player_is_interacting = !player_is_interacting
	if interactable:
		camera.current = false
		interactable = false
	else:
		camera.current = true
		interactable = true
		
func _on_area_3d_body_exited(body: Node3D) -> void:
	if (player_is_interacting):
		solved = true
		letter.visible = true
		camera.current = false
		player.end_interaction()
		print ("box puzzle solved")
		$Puzzle_solved_sound.play()
		$puzzle_solved_particles.emitting = true


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body == ball:
		ball.queue_free()
		ball = null
	


func _on_speedcheck_timeout() -> void:
	check_speed = true
