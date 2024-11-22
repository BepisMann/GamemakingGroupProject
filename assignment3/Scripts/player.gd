extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@onready var player := $Indiana_jones_like_character_final_attempt3
@onready var neck := $Indiana_jones_like_character_final_attempt3/Neck
@onready var camera := $Indiana_jones_like_character_final_attempt3/Neck/Camera3D
@onready var hat := $Indiana_jones_like_character_final_attempt3/Armature/Skeleton3D/hat_001
@onready var hair := $Indiana_jones_like_character_final_attempt3/Armature/Skeleton3D/hair

@onready var anim := $Indiana_jones_like_character_final_attempt3/AnimationPlayer

var is_jumping: bool = false

func _ready() -> void:
	pass

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			var sensitivity := 0.003
			
			rotate_y(-event.relative.x * sensitivity)
			camera.rotate_x(-event.relative.y * sensitivity)
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-30), deg_to_rad(60))
			
			toggle_hat_visibility(camera.rotation.x)
			
func toggle_hat_visibility(pitch: float) -> void:
	if pitch > deg_to_rad(-5):
		hat.visible = false
		hair.visible = false
	else:
		hat.visible = true
		hair.visible = true

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		anim.play("Jumping")

	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction = (transform.basis * Vector3(-input_dir.x, 0, -input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		anim.play("Walking")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		if is_on_floor() && !Input.is_action_just_pressed("ui_accept"):
			anim.play("Idle_1")

	move_and_slide()
