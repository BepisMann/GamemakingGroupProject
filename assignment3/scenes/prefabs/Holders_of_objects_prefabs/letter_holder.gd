extends Node3D
@onready var letter = null
@onready var holding_position = $Letter_holding_position
@onready var holder_collider = $HolderColliderLetter

var is_occupied = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if has_node("Letter_of_code"):
		letter = $"../Letter_of_code"
	elif has_node("Letter_of_translation"):
		letter = $"../Letter_of_translation"
	
	if letter:
		letter.global_transform = holding_position.global_transform
		letter.position += Vector3(0, -1.8, 0)
	else: 
		is_occupied = false
		
	if holder_collider:
		holder_collider.collision_layer = 2
		holder_collider.collision_mask = 2
	update_holder_collider()


func get_is_occupied() -> bool:
	return is_occupied
	

func place_letter(letter_instance):
	if not is_occupied:
		
		var new_letter = letter_instance.duplicate()
		new_letter.name = letter_instance.name
		add_child(new_letter)
		new_letter.global_transform = holding_position.global_transform
		new_letter.position += Vector3(0, -1.8, 0)
		
		var collision_shape = new_letter.get_node("CollisionShape3D")
		if collision_shape:
			collision_shape.disabled = false
		
		new_letter.collision_layer = 2
		new_letter.collision_mask = 2
		new_letter.visible = true
		
		letter_instance.queue_free()
		letter = new_letter
		is_occupied = true
		update_holder_collider()
	
	
func remove_letter():
	letter = null
	is_occupied = false
	update_holder_collider()
	

func update_holder_collider():
	if holder_collider and holder_collider.has_node("CollisionShape3D"):
		var collision_shape = holder_collider.get_node("CollisionShape3D")
		if collision_shape:
			collision_shape.disabled = is_occupied
	var raycast = get_node("../../Player/Indiana_jones_like_character_final_attempt3/Neck/Camera3D/RayCast1")
	
	if raycast:
		raycast.force_raycast_update()
