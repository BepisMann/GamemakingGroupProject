extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@export var left: String = ""
@export var right: String = ""
@onready var player := $Indiana_jones_like_character_final_attempt3
@onready var neck := $Indiana_jones_like_character_final_attempt3/Neck
@onready var camera := $Indiana_jones_like_character_final_attempt3/Neck/Camera3D
@onready var hat := $Indiana_jones_like_character_final_attempt3/Armature/Skeleton3D/hat_001
@onready var hair := $Indiana_jones_like_character_final_attempt3/Armature/Skeleton3D/hair
@onready var raycast := $Indiana_jones_like_character_final_attempt3/Neck/Camera3D/RayCast3D
@onready var label := $Control/Label
@onready var control := $Control/CenterContainer

@onready var left_hand_position := $Indiana_jones_like_character_final_attempt3/LeftHandPosition
@onready var right_hand_position := $Indiana_jones_like_character_final_attempt3/RightHandPosition

@onready var anim := $Indiana_jones_like_character_final_attempt3/AnimationPlayer

signal player_died

var is_jumping: bool = false
var can_control: bool = true

func _ready() -> void:
	if control:
		control.set_raycast(raycast)

func _unhandled_input(event: InputEvent) -> void:
	if (can_control):
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
	
	if (can_control):
		if Input.is_action_just_pressed("left_click"):
			if left == "" and raycast.is_colliding():
				pickup("left")
			elif left != "" and raycast.is_colliding():
				try_place_torch("left")
				
		if Input.is_action_just_pressed("right_click"):
			if right == "" and raycast.is_colliding():
				pickup("right")
			elif right != "" and raycast.is_colliding():
				try_place_torch("right")
			

	# Handle jump and movement.
	if (can_control):
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
	

func try_place_torch(hand):
	var item = raycast.get_collider()
	if item and item.name == "HolderCollider":
		var holder = item.get_parent()
		
		if holder and holder.has_method("get_is_occupied") and not holder.get_is_occupied():
			var torch = (left_hand_position if hand == "left" else right_hand_position).get_child(0)
			holder.place_torch(torch)
			torch.get_parent().remove_child(torch) 
			if hand == "left":
				left = "" 
			else:
				right = "" 


func pickup(hand):
	var item = raycast.get_collider()
	if item and item.name!="HolderCollider":
		if item:
			var collision_shape = item.get_node("CollisionShape3D")
			if collision_shape:
				collision_shape.disabled = true
				
				var parent = item.get_parent()
				if parent:
					if parent.has_method("remove_torch"):
						parent.remove_torch()
					parent.remove_child(item)
				
		if hand == "left":
			self.left = item.name
			left_hand_position.add_child(item)
		else:
			self.right = item.name
			right_hand_position.add_child(item)
		
		reset_item_rotation(item)
		label.show_pickup_message("Picked up " + item.name + str(hand))
	

func reset_item_rotation(item):
	item.transform = Transform3D.IDENTITY
	item.rotate_object_local(Vector3(1, 0, 0), deg_to_rad(0))  # Rotate on X-axis
	item.rotate_object_local(Vector3(0, 1, 0), deg_to_rad(-150))  # Rotate on Y-axis (if needed)


func _on_trap_body_entered_spikes() -> void:
	emit_signal("player_died")
	can_control = false
	velocity.x = move_toward(velocity.x, 0, SPEED)
	velocity.z = move_toward(velocity.z, 0, SPEED)
	anim.play("Idle_1")
