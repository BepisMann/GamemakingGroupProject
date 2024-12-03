extends Node3D

@onready var torch = $Torch
@onready var holding_position = $Torch_holding_position
@onready var holder_collider = $HolderCollider

var is_occupied = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if torch:
		torch.global_transform = holding_position.global_transform
		torch.position += Vector3(-0.02, -1.6, -0.17)
	else: 
		is_occupied = false
		
	if holder_collider:
		holder_collider.collision_layer = 2
		holder_collider.collision_mask = 2
	update_holder_collider()
		
func get_is_occupied() -> bool:
	return is_occupied

		
func place_torch(torch_instance):
	if not is_occupied:
		var new_torch = torch_instance.duplicate()
		new_torch.name = torch_instance.name
		add_child(new_torch)
		new_torch.global_transform = holding_position.global_transform
		new_torch.position += Vector3(-0.02, -1.6, -0.17)
		
		var collision_shape = new_torch.get_node("CollisionShape3D")
		if collision_shape:
			collision_shape.disabled = false
		
		new_torch.collision_layer = 2
		new_torch.collision_mask = 2
		
		torch_instance.queue_free()
		torch = new_torch
		is_occupied = true
		update_holder_collider()
		
	
func remove_torch():
	torch = null
	is_occupied = false
	update_holder_collider()
	
func update_holder_collider():
	if holder_collider and holder_collider.has_node("CollisionShape3D"):
		var collision_shape = holder_collider.get_node("CollisionShape3D")
		if collision_shape:
			collision_shape.disabled = is_occupied
	var raycast = get_node("../Player/Indiana_jones_like_character_final_attempt3/Neck/Camera3D/RayCast2")
	if raycast:
		raycast.force_raycast_update()
