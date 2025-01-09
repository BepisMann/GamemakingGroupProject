extends CharacterBody3D


const SPEED = 5.0
const MAX_SPEED = 12.0
const JUMP_VELOCITY = 4.5
const ACCELERATION_FACTOR = 0.002

@export var left: String = ""
@export var right: String = ""

@onready var player := $Indiana_jones_like_character_final_attempt3
@onready var neck := $Indiana_jones_like_character_final_attempt3/Neck
@onready var camera := $Indiana_jones_like_character_final_attempt3/Neck/Camera3D
@onready var hat := $Indiana_jones_like_character_final_attempt3/Armature/Skeleton3D/hat_001
@onready var hair := $Indiana_jones_like_character_final_attempt3/Armature/Skeleton3D/hair
@onready var raycast1 := $Indiana_jones_like_character_final_attempt3/Neck/Camera3D/RayCast1
@onready var raycast2 := $Indiana_jones_like_character_final_attempt3/Neck/Camera3D/RayCast2
@onready var raycast_chess := $Indiana_jones_like_character_final_attempt3/Neck/Camera3D/RayCastChess
@onready var raycast_chess_move_piece := $Indiana_jones_like_character_final_attempt3/Neck/Camera3D/RayCastChessMovePiece
@onready var label := $Control/Label
@onready var control := $Control/CenterContainer

@onready var left_hand_position := $Indiana_jones_like_character_final_attempt3/LeftHandPosition
@onready var right_hand_position := $Indiana_jones_like_character_final_attempt3/RightHandPosition

@onready var anim := $Indiana_jones_like_character_final_attempt3/AnimationPlayer

var held_torch_count: int = 0

signal player_died
signal piece_touched
signal piece_moved

var pressed_buttons: Array = []
var correct_code: Array = []

var puzzle_solved: bool = false

var is_jumping: bool = false
var is_running: float = true
var current_speed: float = SPEED
var can_control: bool = true
var can_jump: bool = true
var spawn_point = 1

@onready var pickup_sound = $Pickup_sound
@onready var placing_sound = $Place_item_sound
@onready var backgroundMusic1 = $Background_music_1
@onready var stop_timer = $Background_music_1/BackgroundMusicLoopTimer
@onready var death_sound = $Death_sound

func _ready() -> void:
	if control:
		control.set_raycast(raycast1, 1)
		control.set_raycast(raycast2, 2)
		control.set_raycast(raycast_chess, 3)
		control.set_raycast(raycast_chess_move_piece, 4)
	
	backgroundMusic1.play()
	stop_timer.start()
	
	correct_code = ["Button3", "Button13", "Button15", "Button6"]
	for button_name in correct_code:
		var button = $"../room3/walls/Wall9/CodeBoard/BackGroundBoard".get_node(button_name)
		if button:
			button.is_locked = false
	


func _on_background_music_loop_timer_timeout() -> void:
	backgroundMusic1.stop()
	backgroundMusic1.play()
	stop_timer.start()
	
func _on_death_sound_loop_timer_timeout() -> void:
	death_sound.stop()
	death_sound.play()
	$Death_sound/DeathSoundLoopTimer.start()
	

func _unhandled_input(event: InputEvent) -> void:
	if (can_control):
		if event is InputEventMouseButton:
			if event.pressed:
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			if event is InputEventMouseMotion:
				var sensitivity := 0.003
				
				rotate_y(-event.relative.x * sensitivity)
				camera.rotate_x(-event.relative.y * sensitivity)
				camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-60), deg_to_rad(60))
				
				toggle_hat_visibility(camera.rotation.x)
	if event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
func interact_with_button(button: StaticBody3D) -> void:
	if button.has_method("is_pressed"):
		button.is_pressed = true
		
		print("Button pressed:", button.name)

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
		if raycast_chess_move_piece.is_colliding() && (Input.is_action_just_pressed("left_click") || Input.is_action_just_pressed("right_click")):
			move_selected_piece_to_location()
		elif raycast_chess.is_colliding() && (Input.is_action_just_pressed("left_click") || Input.is_action_just_pressed("right_click")):
			interact_chess_piece()
		elif raycast2.is_colliding() && (Input.is_action_just_pressed("left_click") || Input.is_action_just_pressed("right_click")) and raycast2.get_collider().name == "Box_Puzzle":
			player.visible =  false
			camera.current = false
			var item = raycast2.get_collider()
			item.interact(self)
			can_control = false
		elif Input.is_action_just_pressed("left_click"):
			if left == "" and raycast2.is_colliding():
				pickup("left")
			elif left != "" and raycast2.is_colliding():
				if raycast2.get_collider().name == "HolderCollider":
					try_place_torch("left")
				elif raycast2.get_collider().name == "HolderColliderMedallion":
					try_place_medallion("left")
				elif raycast2.get_collider().name == "HolderColliderMap":
					try_place_trap_map("left")
				elif raycast2.get_collider().name == "HolderColliderLetter":
					try_place_letter("left")
				placing_sound.playing = true
				
				if raycast2.get_collider().name.begins_with("Button"):
					pickup("left")

		elif Input.is_action_just_pressed("right_click"):
			if right == "" and raycast2.is_colliding():
				pickup("right")
			elif right != "" and raycast2.is_colliding():
				if raycast2.get_collider().name == "HolderCollider":
					try_place_torch("right")
				elif raycast2.get_collider().name == "HolderColliderMedallion":
					try_place_medallion("right")
				elif raycast2.get_collider().name == "HolderColliderMap":
					try_place_trap_map("right")
				elif raycast2.get_collider().name == "HolderColliderLetter":
					try_place_letter("right")
				placing_sound.playing = true
				
				if raycast2.get_collider().name.begins_with("Button"):
					pickup("right")
			
	elif not can_control:
		if raycast2.is_colliding() && (Input.is_action_just_pressed("left_click") || Input.is_action_just_pressed("right_click")) and raycast2.get_collider().name == "Box_Puzzle":
			end_interaction()

	# Handle jump and movement.
	if (can_control):
		if (can_jump):
			if Input.is_action_just_pressed("ui_accept") and is_on_floor():
				velocity.y = JUMP_VELOCITY
				anim.play("Jumping")

		var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
		var direction = (transform.basis * Vector3(-input_dir.x, 0, -input_dir.y)).normalized()
		if direction:
			if is_running:
				current_speed = sqrt(velocity.x * velocity.x + velocity.z * velocity.z)
				current_speed = max(SPEED, current_speed)
				current_speed = min(current_speed + SPEED * ACCELERATION_FACTOR, MAX_SPEED)
				velocity.x = direction.x * current_speed
				velocity.z = direction.z * current_speed
				anim.play("Walking")
			else:
				velocity.x = direction.x * SPEED
				velocity.z = direction.z * SPEED
				anim.play("Walking")
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
			if is_on_floor() && !Input.is_action_just_pressed("ui_accept"):
				anim.play("Idle_1")

	move_and_slide()


func try_place_letter(hand):
	var item = raycast2.get_collider()
	if item and item.name == "HolderColliderLetter":
		var holder = item.get_parent()
		
		if holder and holder.has_method("get_is_occupied") and not holder.get_is_occupied():
			if hand == "left":
				if self.left == "Letter_of_code":
					$"../UI/LetterUI/Code_letter_left".visible = false
				elif self.left == "Letter_of_translation":
					$"../UI/LetterUI/Translation_letter_left".visible = false
			elif hand == "right":
				if self.right == "Letter_of_code":
					$"../UI/LetterUI/Code_letter_right".visible = false
				elif self.right == "Letter_of_translation":
					$"../UI/LetterUI/Translation_letter_right".visible = false
					
			var letter = (left_hand_position if hand == "left" else right_hand_position).get_child(0)
			
			if not letter.name.begins_with("Letter"):
				return
			
			holder.place_letter(letter)
			letter.get_parent().remove_child(letter)
			if hand == "left":
				left = "" 
			else:
				right = "" 

func try_place_trap_map(hand):
	var item = raycast2.get_collider()
	if item and item.name == "HolderColliderMap":
		var holder = item.get_parent()
		
		if holder and holder.has_method("get_is_occupied") and not holder.get_is_occupied():
			if hand == "left":
				if self.left == "TrapMap1":
					$"../UI/TrapMapUI/Pit_trap_left".visible = false
				elif self.left == "TrapMap2":
					$"../UI/TrapMapUI/Spike_trap_left".visible = false
			elif hand == "right":
				if self.right == "TrapMap1":
					$"../UI/TrapMapUI/Pit_trap_right".visible = false
				elif self.right == "TrapMap2":
					$"../UI/TrapMapUI/Spike_trap_right".visible = false
			
			
			var map = (left_hand_position if hand == "left" else right_hand_position).get_child(0)
			
			if not map.name.begins_with("TrapMap"):
				return
			
			holder.place_map(map)
			map.get_parent().remove_child(map)
			if hand == "left":
				left = "" 
			else:
				right = "" 


func try_place_torch(hand):
	var item = raycast2.get_collider()
	if item and item.name == "HolderCollider":
		var holder = item.get_parent()
		
		if holder and holder.has_method("get_is_occupied") and not holder.get_is_occupied():
			var torch = (left_hand_position if hand == "left" else right_hand_position).get_child(0)
			
			if not torch.name.begins_with("Torch"):
				return
			
			holder.place_torch(torch)
			torch.get_parent().remove_child(torch)
			held_torch_count -= 1 
			if hand == "left":
				left = "" 
			else:
				right = "" 
				
func try_place_medallion(hand):
	print("part 1")
	var item = raycast2.get_collider()
	if item and item.name == "HolderColliderMedallion":
		print("part 2")
		var holder = item.get_parent()
		
		if holder and holder.has_method("get_is_occupied") and not holder.get_is_occupied():
			print("part 3")
			var hand_position = left_hand_position if hand == "left" else right_hand_position
			print(hand_position.get_child_count())
			if hand_position.get_child_count() > 0:
				print("part 4")
				var medallion = hand_position.get_child(0)
				
				if not medallion.name.begins_with("Medallion"):
					print("Error: Only medallions can be placed in this holder.")
					return
				
				holder.place_medallion(medallion)
				hand_position.remove_child(medallion)
				if hand == "left":
					left = "" 
				else:
					right = "" 
				
				print("medallion placed")
		


func interact_chess_piece():
	var piece = raycast_chess.get_collider()
	emit_signal("piece_touched", piece)
	
func move_selected_piece_to_location():
	var destination_indicator = raycast_chess_move_piece.get_collider()
	emit_signal("piece_moved", destination_indicator)

func set_spawn_point_2():
	spawn_point = 2
	
func get_respawn_point() -> int:
	return spawn_point

func pickup(hand):
	if raycast2.get_collision_mask_value(2):
		var item = raycast2.get_collider()
		if item and item.name!="HolderCollider" and item.name!= "HolderColliderMedallion" and item.name != "HolderColliderMap" and item.name!= "HolderColliderLetter":
			if item.name.to_lower().contains("button"):
				if puzzle_solved:
					return
				var button_name = String(item.name)
				if not pressed_buttons.has(button_name):
					item.is_pressed = true
					$"../room3/walls/Wall9/CodeBoard/Button_pressed_sound".play()
					pressed_buttons.append(button_name)
					print(pressed_buttons)
					check_code()
				return
			if !("is_locked" in item) || (item.is_locked == false):
				if not item.name.to_lower().contains("wall") and not item.name.to_lower().contains("floor") and not item.name.to_lower().contains("ceiling") and not item.name.to_lower().contains("end_door"):
					if item:
						pickup_sound.playing = true
						print("Picking up item:", item.name)
						var collision_shape = item.get_node("CollisionShape3D")
						if collision_shape:
							collision_shape.disabled = true
							
						var parent = item.get_parent()
						if parent and parent.has_method("remove_medallion"):
							print("Removing medallion from holder.")
							label.show_pickup_message("It's stuck in place!")
							var medallion_from_holder = parent.remove_medallion()
							if medallion_from_holder:
								print(type_string(typeof(medallion_from_holder)))
								if type_string(typeof(medallion_from_holder)) == "int":
									label.show_pickup_message("It's stuck in place!")
									item = null
								else:
									item = medallion_from_holder
							else:
								item = null
						if parent and parent.has_method("remove_torch"):
							print("Removing torch from holder.")
							parent.remove_torch()
						if parent and parent.has_method("remove_map"):
							print("Removing map from holder.")
							parent.remove_map()
						if parent and parent.has_method("remove_letter"):
							print("Removing letter from holder.")
							parent.remove_letter()
						if not item == null:
							parent.remove_child(item)
							if hand == "left":
								print("Adding item to left hand.")
								left_hand_position.add_child(item)
								self.left = item.name
								reset_item_rotation_left(item)
								if item.name.begins_with("TrapMap"):
									item.get_parent().visible = false
								if item.name.begins_with("Letter"):
									item.get_parent().visible = false
								if item.name.begins_with("Torch"):
									held_torch_count += 1
							
							else:
								print("Adding item to right hand.")
								right_hand_position.add_child(item)
								self.right = item.name
								reset_item_rotation_right(item)
								if item.name.begins_with("TrapMap"):
									item.get_parent().visible = false
								if item.name.begins_with("Letter"):
									item.get_parent().visible = false
								if item.name.begins_with("Torch"):
									held_torch_count += 1
						
							print("Item parent after pickup:", item.get_parent().name)
						
							if not item.name.begins_with("TrapMap"):
								item.visible = true
							if not item.name.begins_with("Letter"):
								item.visible = true
						
							item.collision_layer = 2
							item.collision_mask = 2
						
							label.show_pickup_message("Picked up " + item.name + str(hand))
					else:
						print("Error: No valid item to pick up!")

func check_code():
	if pressed_buttons.size() == 4:
		print("Pressed buttons:", pressed_buttons)
		print("Correct code:", correct_code)
		if pressed_buttons == correct_code:
			print("Final door opened!")
			$Puzzle_solved_sound.play()
			lock_correct_buttons()
			puzzle_solved = true
			$"../room3/walls/Wall9/CodeBoard/puzzle_solved_particles".emitting = true
			$"../room3/Static_end_door/AudioStreamPlayer3D".play()
			$"../room3/Static_end_door/End_door/AnimationPlayer2".play("Spike_009Action_001")
			$"../room3/Static_end_door/End_door/AnimationPlayer3".play("links schanieren_003Action")
			$"../room3/Static_end_door/End_door/AnimationPlayer4".play("rechts schanieren_001Action")
			$EndDoorTimer.start()
			
		else:
			reset_buttons()
			

func _on_end_door_timer_timeout() -> void:
	$"../room3/Static_end_door/middle_hitbox".disabled = true


func lock_correct_buttons():
	var codeboard = $"../room3/walls/Wall9/CodeBoard/BackGroundBoard"
	if codeboard:
		for button in codeboard.get_children():
			if button.has_method("is_locked"):  # Check if the button has 'is_locked
				button.is_locked = true
	print("Correct buttons are locked!")
	pressed_buttons.clear()

func reset_buttons():
	for button_name in pressed_buttons:
		var button_path = NodePath("../room3/walls/Wall9/CodeBoard/BackGroundBoard/" + button_name)
		var button = get_node(button_path)
		if button:
			button.is_pressed = false
			button.global_transform.origin = button.initial_position  # Reset position
	pressed_buttons.clear()
	$Failed_puzzle_sound.play()
	
	print("Buttons reset after incorrect attempt!")


func _on_trap_room_room_3_player_died() -> void:
	emit_signal("player_died")
	$Control/CenterContainer.hide()
	can_control = false
	velocity.x = move_toward(velocity.x, 0, SPEED)
	velocity.z = move_toward(velocity.z, 0, SPEED)
	anim.play("Idle_1")
	$Death_sound/DeathSoundDelay.start()
	backgroundMusic1.stop()
	
func _on_death_sound_delay_timeout() -> void:
	death_sound.play()
	$Death_sound/DeathSoundLoopTimer.start()
	
func respawn() -> void:
	$Death_sound/DeathSoundLoopTimer.stop()
	death_sound.stop()
	backgroundMusic1.play()
	stop_timer.start()
	
func show_cursor():
	$Control/CenterContainer.show()
	
func reset_item_rotation_left(item):
	item.transform = Transform3D.IDENTITY
	
	match item.name:
		"Torch":
			item.rotate_object_local(Vector3(1, 0, 0), deg_to_rad(0))
			item.rotate_object_local(Vector3(0, 1, 0), deg_to_rad(-150))
		
		"MedallionBird":
			item.rotate_object_local(Vector3(0, 0, 1), deg_to_rad(30))
			item.rotate_object_local(Vector3(0, 1, 0), deg_to_rad(-120))
			item.position += Vector3(0, 1.5, 0)
			
		"MedallionSnake":
			item.rotate_object_local(Vector3(0, 0, 1), deg_to_rad(30))
			item.rotate_object_local(Vector3(0, 1, 0), deg_to_rad(-120))
			item.position += Vector3(-0.15, 1.5, 0)
			
		"MedallionFish":
			item.rotate_object_local(Vector3(0, 0, 1), deg_to_rad(30))
			item.rotate_object_local(Vector3(0, 1, 0), deg_to_rad(-120))
			item.position += Vector3(-0.15, 1.5, 0)
			
		"MedallionScarab":
			item.rotate_object_local(Vector3(0, 0, 1), deg_to_rad(30))
			item.rotate_object_local(Vector3(0, 1, 0), deg_to_rad(-120))
			item.position += Vector3(-0.15, 1.5, 0)
			
		"TrapMap1":
			$"../UI/TrapMapUI/Pit_trap_left".visible = true
		
		"TrapMap2":
			$"../UI/TrapMapUI/Spike_trap_left".visible = true
		
		"Letter_of_code":
			$"../UI/LetterUI/Code_letter_left".visible = true
		
		"Letter_of_translation":
			$"../UI/LetterUI/Translation_letter_left".visible = true

func reset_item_rotation_right(item):
	item.transform = Transform3D.IDENTITY
	
	match item.name:
		"Torch":
			item.rotate_object_local(Vector3(1, 0, 0), deg_to_rad(0))
			item.rotate_object_local(Vector3(0, 1, 0), deg_to_rad(-150))
		
		"MedallionBird":
			item.rotate_object_local(Vector3(0, 0, 1), deg_to_rad(-30))
			item.rotate_object_local(Vector3(0, 1, 0), deg_to_rad(150))
			item.position += Vector3(-0.15, 1.5, 0)
			
		"MedallionSnake":
			item.rotate_object_local(Vector3(0, 0, 1), deg_to_rad(-30))
			item.rotate_object_local(Vector3(0, 1, 0), deg_to_rad(150))
			item.position += Vector3(-0.15, 1.5, 0)
			
		"MedallionFish":
			item.rotate_object_local(Vector3(0, 0, 1), deg_to_rad(-30))
			item.rotate_object_local(Vector3(0, 1, 0), deg_to_rad(150))
			item.position += Vector3(-0.15, 1.5, 0)
			
		"MedallionScarab":
			item.rotate_object_local(Vector3(0, 0, 1), deg_to_rad(-30))
			item.rotate_object_local(Vector3(0, 1, 0), deg_to_rad(150))
			item.position += Vector3(-0.15, 1.5, 0)
		
		"TrapMap1":
			$"../UI/TrapMapUI/Pit_trap_right".visible = true
			
		"TrapMap2":
			$"../UI/TrapMapUI/Spike_trap_right".visible = true
			
		"Letter_of_code":
			$"../UI/LetterUI/Code_letter_right".visible = true
		
		"Letter_of_translation":
			$"../UI/LetterUI/Translation_letter_right".visible = true


func end_interaction():
	player.visible =  false
	camera.current = false
	var item = raycast2.get_collider()
	item.interact(self)
	can_control = true
