extends CenterContainer

@export var DOT_RADIUS: float = 3.0
@export var DOT_COLOR: Color = Color.WHITE
@onready var raycast1 := get_node("../../Indiana_jones_like_character_final_attempt3/Neck/Camera3D/RayCast1")
@onready var raycast2 := get_node("../../Indiana_jones_like_character_final_attempt3/Neck/Camera3D/RayCast2")
var left_hand : Node3D 
var right_hand : Node3D
var left : String
var right : String
@onready var raycast_chess := get_node("../../Indiana_jones_like_character_final_attempt3/Neck/Camera3D/RayCastChess")
@onready var raycast_chess_move_piece := get_node("../../Indiana_jones_like_character_final_attempt3/Neck/Camera3D/RayCastChessMovePiece")


func set_raycast(raycast_node: RayCast3D, ray):
	if ray == 1:
		raycast1 = raycast_node
	elif ray == 2:
		raycast2 = raycast_node
	elif ray == 3:
		raycast_chess = raycast_node
	elif ray == 4:
		raycast_chess_move_piece = raycast_node
	queue_redraw()

func _process(delta: float) -> void:
	
	if raycast2 and raycast2.is_colliding():
		var collider = raycast2.get_collider()
		var parent = null
		if collider.has_method("get_parent"):
			parent = collider.get_parent()
		if collider and collider.has_method("get_collision_layer"):
			var collider_layer = collider.collision_layer
			if collider_layer & (1<<1):
				if left and right and ((parent.has_method("get_is_occupied") and parent.get_is_occupied() == true) or (collider.name.contains("Letter") or collider.name.contains("Medallion"))):
					DOT_COLOR = Color.RED
				elif parent.name.contains("torch") and not (left.contains("Torch") or right.contains("Torch")) and parent.has_method("get_is_occupied") and parent.get_is_occupied() == false:
					DOT_COLOR = Color.RED
				elif parent.name.contains("letter") and not (left.contains("Letter") or right.contains("Letter")) and parent.has_method("get_is_occupied") and parent.get_is_occupied() == false:
					DOT_COLOR = Color.RED
				elif parent.name.contains("Medaillon") and not (left.contains("Medallion") or right.contains("Medallion")) and parent.has_method("get_is_occupied") and parent.get_is_occupied() == false:
					DOT_COLOR = Color.RED
				elif parent.name.contains("map") and not (left.contains("Map") or right.contains("Map")) and parent.has_method("get_is_occupied") and parent.get_is_occupied() == false:
					DOT_COLOR = Color.RED
				else:
					DOT_COLOR = Color.GREEN
			else:
				DOT_COLOR = Color.WHITE
	elif raycast1 and raycast1.is_colliding():
		var collider = raycast1.get_collider()
		if collider and collider.has_method("get_collision_layer"):
			var collider_layer = collider.collision_layer
			if collider_layer & (1<<1):
				DOT_COLOR = Color.RED
			else:
				DOT_COLOR = Color.WHITE
	else:
		DOT_COLOR = Color.WHITE

	queue_redraw()

func set_left_and_right_hand(left_s, right_s, left_h, right_h):
	left_hand = left_h
	right_hand = right_h
	left = left_s
	right = right_s
func _draw():
	var center = get_rect().size / 2
	draw_circle(center, DOT_RADIUS, DOT_COLOR)  # Draw the hover dot
