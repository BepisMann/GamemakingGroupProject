extends Node3D

signal piece_moved
signal piece_touched

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func reset_chess() -> void:
	$ChessRoom/ChessRoom.reset()
	await get_tree().create_timer(0.5).timeout
	$ChessRoom/RestartButton.is_pressed = false
	
func _on_player_piece_touched(body: Object) -> void:
	emit_signal("piece_touched", body)


func _on_player_piece_moved(body: Object) -> void:
	emit_signal("piece_moved", body)


func _on_chess_room_player_won_chess() -> void:
	$ChessRoom/ChessRoom.queue_free()
	$ChessRoom/RestartButton.queue_free()
	$ChessRoom/Letter_before_solution/Letter_of_translation.reparent($ChessRoom/Letter_of_translation_position, false)
