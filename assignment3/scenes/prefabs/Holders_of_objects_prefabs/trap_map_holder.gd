extends Node3D
@onready var map = null
@onready var holding_position = $Map_holding_position
@onready var holder_collider = $HolderColliderMap

var is_occupied = true

var raycast: Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	raycast = find_raycast_from_group()
	
	if has_node("TrapMap1"):
		map = $TrapMap1
	elif has_node("TrapMap2"):
		map = $TrapMap2
	
	if map:
		map.global_transform = holding_position.global_transform
		map.position += Vector3(0, -1.8, 0)
	else: 
		is_occupied = false
		
	if holder_collider:
		holder_collider.collision_layer = 2
		holder_collider.collision_mask = 2
	update_holder_collider()

func get_is_occupied() -> bool:
	return is_occupied


func place_map(map_instance):
	if not is_occupied:
		
		var new_map = map_instance.duplicate()
		new_map.name = map_instance.name
		add_child(new_map)
		new_map.global_transform = holding_position.global_transform
		new_map.position += Vector3(0, -1.8, 0)
		
		var collision_shape = new_map.get_node("CollisionShape3D")
		if collision_shape:
			collision_shape.disabled = false
		
		new_map.collision_layer = 2
		new_map.collision_mask = 2
		new_map.visible = true
		
		map_instance.queue_free()
		map = new_map
		is_occupied = true
		update_holder_collider()


func remove_map():
	map = null
	is_occupied = false
	update_holder_collider()


func update_holder_collider():
	if holder_collider and holder_collider.has_node("CollisionShape3D"):
		var collision_shape = holder_collider.get_node("CollisionShape3D")
		if collision_shape:
			collision_shape.disabled = is_occupied
	# var raycast = get_node("../../Player/Indiana_jones_like_character_final_attempt3/Neck/Camera3D/RayCast1")
	if raycast:
		raycast.force_raycast_update()
		

func find_raycast_from_group() -> Node:
	var raycasts = get_tree().get_nodes_in_group("raycast_group")
	if raycasts.size() > 0:
		return raycasts[0]  # Return the first one found
	return null
