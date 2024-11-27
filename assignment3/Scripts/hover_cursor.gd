extends CenterContainer

@export var DOT_RADIUS: float = 3.0
@export var DOT_COLOR: Color = Color.WHITE
@onready var raycast := $Neck/Camera3D/RayCast3D



func set_raycast(raycast_node: RayCast3D):
	raycast = raycast_node
	queue_redraw()

func _process(delta: float) -> void:
	if raycast and raycast.is_colliding():
		DOT_COLOR = Color.RED
	else:
		DOT_COLOR = Color.WHITE

	queue_redraw()

func _draw():
	var center = get_rect().size / 2
	draw_circle(center, DOT_RADIUS, DOT_COLOR)  # Draw the hover dot
