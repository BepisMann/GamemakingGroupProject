extends CenterContainer

@export var DOT_RADIUS: float = 3.0
@export var DOT_COLOR: Color = Color.WHITE
@onready var raycast := get_node("../../Indiana_jones_like_character_final_attempt3/Neck/Camera3D/RayCast3D")



func set_raycast(raycast_node: RayCast3D):
	raycast = raycast_node
	queue_redraw()

func _process(delta: float) -> void:
	if raycast and raycast.is_colliding():
		var collider = raycast.get_collider()
		if collider and (collider.name == "Torch" or (collider.name == "HolderCollider" and collider.get_parent().has_method("is_occupied") and not collider.get_parent().is_occupied())):
			DOT_COLOR = Color.RED
		elif collider and collider.name == "HolderCollider":
			DOT_COLOR = Color.RED
		else:
			DOT_COLOR = Color.WHITE
		
	else:
		DOT_COLOR = Color.WHITE

	queue_redraw()

func _draw():
	var center = get_rect().size / 2
	draw_circle(center, DOT_RADIUS, DOT_COLOR)  # Draw the hover dot
