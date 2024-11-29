extends Node3D

@export var required_type: String

@onready var holding_position = $HoldingPosition
@onready var holder_collider = $HolderColliderMedallion

var is_occupied = false
var medallion: Node = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if holder_collider:
		holder_collider.collision_layer = 2
		holder_collider.collision_mask = 2
	update_holder_collider()

func get_is_occupied() -> bool:
	return is_occupied

func place_medallion(medallion_instance):
	if not medallion_instance.name.begins_with("Medallion"):
		print("Error: Attempted to place a non-medallion item in a medallion holder.")
		return
	
	if not is_occupied and medallion_instance:
		var new_medallion = medallion_instance.duplicate()
		new_medallion.name = medallion_instance.name
		add_child(new_medallion)
		new_medallion.global_transform = holding_position.global_transform
		new_medallion.scale = Vector3(1.9, 1.9, 1.9)
		new_medallion.position += Vector3(0, 0.6, 0.065)
		new_medallion.rotate_object_local(Vector3(1, 0, 0), deg_to_rad(90))
		
		var collision_shape = new_medallion.get_node("CollisionShape3D")
		if collision_shape:
			collision_shape.disabled = false
			
		new_medallion.collision_layer = 2
		new_medallion.collision_mask = 2
		
		medallion_instance.queue_free()
		medallion = new_medallion
		is_occupied = true
		update_holder_collider()
		notify_puzzle_manager()
		
func notify_puzzle_manager():
	var puzzle_manager = get_parent()
	if puzzle_manager and puzzle_manager.has_method("update_puzzle_state"):
		puzzle_manager.update_puzzle_state()

func remove_medallion():
	if medallion:
		is_occupied = false
		update_holder_collider()
		var temp = medallion
		medallion = null
		return temp
		notify_puzzle_manager()

func check_correct_medallion() -> bool:
	if not is_occupied or not medallion:
		return false
	
	return medallion.medallion_type == required_type
		

func update_holder_collider():
	if holder_collider and holder_collider.has_node("CollisionShape3D"):
		var collision_shape = holder_collider.get_node("CollisionShape3D")
		if collision_shape:
			collision_shape.disabled = is_occupied
