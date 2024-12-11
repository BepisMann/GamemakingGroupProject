extends CenterContainer

@export var DOT_RADIUS: float = 3.0
@export var DOT_COLOR: Color = Color.WHITE
@onready var raycast1 := get_node("../../Indiana_jones_like_character_final_attempt3/Neck/Camera3D/RayCast1")
@onready var raycast2 := get_node("../../Indiana_jones_like_character_final_attempt3/Neck/Camera3D/RayCast2")


func set_raycast(raycast_node: RayCast3D, ray):
	if ray == 1:
		raycast1 = raycast_node
	else:
		raycast2 = raycast_node
	queue_redraw()

func _process(delta: float) -> void:
	if raycast2 and raycast2.is_colliding():
		var collider = raycast2.get_collider()
		if collider and collider.has_method("get_collision_layer"):
			var collider_layer = collider.collision_layer
			if collider_layer & (1<<1):
				if collider and (collider.name == "Torch" or (collider.name == "HolderCollider" and collider.get_parent().has_method("is_occupied") and not collider.get_parent().is_occupied())):
					DOT_COLOR = Color.GREEN
				elif collider and collider.name == "HolderCollider":
					DOT_COLOR = Color.GREEN
				elif collider and (collider.name.begins_with("Medallion") or (collider.name == "HolderColliderMedallion" and collider.get_parent().has_method("is_occupied") and not collider.get_parent().is_occupied())):
					DOT_COLOR = Color.GREEN
				elif collider and collider.name == "HolderColliderMedallion":
					DOT_COLOR = Color.GREEN
				elif collider and collider.name.to_lower().contains("collidermap") or  collider.name.to_lower().contains("trapmap"):
					DOT_COLOR = Color.GREEN
				else:
					DOT_COLOR = Color.WHITE
			else:
				DOT_COLOR = Color.WHITE
	elif raycast1 and raycast1.is_colliding():
		var collider = raycast1.get_collider()
		if collider and collider.has_method("get_collision_layer"):
			var collider_layer = collider.collision_layer
			if collider_layer & (1<<1):
				if collider and (collider.name == "Torch" or (collider.name == "HolderCollider" and collider.get_parent().has_method("is_occupied") and not collider.get_parent().is_occupied())):
					DOT_COLOR = Color.RED
				elif collider and collider.name == "HolderCollider":
					DOT_COLOR = Color.RED
				elif collider and (collider.name.begins_with("Medallion") or (collider.name == "HolderColliderMedallion" and collider.get_parent().has_method("is_occupied") and not collider.get_parent().is_occupied())):
					DOT_COLOR = Color.RED
				elif collider and collider.name == "HolderColliderMedallion":
					DOT_COLOR = Color.RED
				elif collider and collider.name.to_lower().contains("collidermap") or  collider.name.to_lower().contains("trapmap"):
					DOT_COLOR = Color.RED
				else:
					DOT_COLOR = Color.WHITE
			else:
				DOT_COLOR = Color.WHITE
	else:
		DOT_COLOR = Color.WHITE

	queue_redraw()

func _draw():
	var center = get_rect().size / 2
	draw_circle(center, DOT_RADIUS, DOT_COLOR)  # Draw the hover dot
