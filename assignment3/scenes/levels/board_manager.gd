extends Node3D

@onready
var board: Object = $"../Board"

var white_to_move: bool = true
var move_log: Array = []
var white_move_log: Array = []
var black_move_log: Array = []

var current_white_moves: Array = []
var current_black_moves: Array = []

var castleFromKing: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide_move_here_indicators()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
## GENERAL HELPER METHODS
func get_tile(row: int, column: int) -> Object:
	var board_row = board.get_child(row-1)
	var tile = board_row.get_child(column-1)
	return tile
	
func get_tile_piece(tile: Object) -> Object:
	if tile.get_children().size() <= 3:
		return null
	return tile.get_child(3)
	
func get_move_here_indicator(row: int, column: int) -> Object:
	var board_row = board.get_child(row-1)
	var tile = board_row.get_child(column-1)
	var move_here_indicator = tile.get_child(2)
	
	return move_here_indicator
	
func get_column_letter(col: int) -> String:
	match col:
		1:
			return "a"
		2:
			return "b"
		3:
			return "c"
		4:
			return "d"
		5:
			return "e"
		6:
			return "f"
		7:
			return "g"
		8:
			return "h"
		_:
			return "?"
			
func get_column_number(col: String) -> int:
	match col:
		"a":
			return 1
		"b":
			return 2
		"c":
			return 3
		"d":
			return 4
		"e":
			return 5
		"f":
			return 6
		"g":
			return 7
		"h":
			return 8
		_:
			return -1
			
## GAME PROCESSING
func hide_move_here_indicators():
	for i in range(8):
		for j in range(8):
			var indicator = get_move_here_indicator(i+1, j+1)
			var collision: CollisionShape3D = indicator.get_child(0).get_child(1)
			collision.set_deferred("disabled", true)
			
			indicator.hide()
			
func get_destination_from_notation(move: String) -> Array:
	# Is this castling kingside?
	if move == "0-0":
		if white_to_move:
			if castleFromKing:
				return [1,8]
			else:
				return [1,5]
		else:
			if castleFromKing:
				return [8, 8]
			else:
				return [8, 5]
	
	# Is this castling queenside?
	elif move == "0-0-0":
		if white_to_move:
			if castleFromKing:
				return [1,1]
			else:
				return [1,5]
		else:
			if castleFromKing:
				return [8, 1]
			else:
				return [8, 5]
				
	# Is this a piece move or a pawn move
	elif move.begins_with("R") || move.begins_with("N") || move.begins_with("B") || move.begins_with("Q") || move.begins_with("K"):
		# Does move involve a capture?
		if move.contains("x"):
			return [move[4].to_int(), get_column_number(move[5])]
		else:
			return [move[3].to_int(), get_column_number(move[4])]
	else:
		# Does move involve a capture?
		if move.contains("x") || move.contains(":"):
			return [move[3].to_int(), get_column_number(move[4])]
		else:
			return [move[2].to_int(), get_column_number(move[3])]
		
func get_start_from_notation(move: String) -> Array:
	# Is this a piece move or a pawn move
	if move.begins_with("R") || move.begins_with("N") || move.begins_with("B") || move.begins_with("Q") || move.begins_with("K"):
		return [move[1].to_int(), get_column_number(move[2])]
	else:
		return [move[0].to_int(), get_column_number(move[1])]
		
func show_move_indicators(moves: Array):
	for move in moves:
		var row = -1
		var col = -1
		if (move == "0-0"):
			if castleFromKing:
				if white_to_move:
					row = 1
					col = 8
				else:
					row = 8
					col = 8
			else:
				if white_to_move:
					row = 1
					col = 5
				else:
					row = 8
					col = 5 
				
		elif (move == "0-0-0"):
			if castleFromKing:
				if white_to_move:
					row = 1
					col = 1
				else:
					row = 8
					col = 1
			else:
				if white_to_move:
					row = 1
					col = 5
				else:
					row = 8
					col = 5
					
		else:
			var dest = get_destination_from_notation(move)
			row = dest[0]
			col = dest[1]
			
		var indicator = get_move_here_indicator(row, col)
		indicator.show()
			
		var collision: CollisionShape3D = indicator.get_child(0).get_child(1)
		collision.set_deferred("disabled", false)
			
		var animation_player: AnimationPlayer = indicator.get_child(1)
		animation_player.play("float_indicator", -1, 2.0)
			
func _on_player_piece_touched(body: Object) -> void:
	var piece: Object = body.get_parent()
	var tile: Object = piece.get_parent()
	var row_obj: Object = tile.get_parent()
	
	var row: int = row_obj.name.to_int()
	var col: int = get_column_number(tile.name)
	
	if piece.name.to_lower().contains("black") && white_to_move:
		print("White to move!")
	elif piece.name.to_lower().contains("white") && !white_to_move:
		print("Black to move!")
	
	elif !white_to_move:
		# Hide other indicators
		hide_move_here_indicators()
		
		var moves = []
		match piece.name:
			"BlackPawn":
				moves = compute_black_pawn_moves(row, col)
			"BlackRook":
				moves = compute_black_rook_moves(row, col)
			"BlackKnight":
				moves = compute_black_knight_moves(row, col)
			"BlackBishop":
				moves = compute_black_bishop_moves(row, col)
			"BlackQueen":
				moves = compute_black_queen_moves(row, col)
			"BlackKing":
				moves = compute_black_king_moves(row, col)
			_:
				print("INVALID PIECE")
		print(moves)
		show_move_indicators(moves)
		current_black_moves = moves
		
	else:
		# Hide other indicators
		hide_move_here_indicators()
		
		var moves = []
		match piece.name:
			"WhitePawn":
				moves = compute_white_pawn_moves(row, col)
			"WhiteRook":
				moves = compute_white_rook_moves(row, col)
			"WhiteKnight":
				moves = compute_white_knight_moves(row, col)
			"WhiteBishop":
				moves = compute_white_bishop_moves(row, col)
			"WhiteQueen":
				moves = compute_white_queen_moves(row, col)
			"WhiteKing":
				moves = compute_white_king_moves(row, col)
			_:
				print("INVALID PIECE")
		print(moves)
		show_move_indicators(moves)
		current_white_moves = moves
			
func _on_player_piece_moved(body: Object) -> void:
	var indicator = body.get_parent()
	var tile = indicator.get_parent()
	var row_obj = tile.get_parent()
	
	var row: int = row_obj.name.to_int()
	var col: int = get_column_number(tile.name)
	
	if (white_to_move):
		for move in current_white_moves:
			var dest = get_destination_from_notation(move)
			
			# TODO:: Pawn promotion?
			
			if dest[0] == row && dest[1] == col:
				resolve_move(move)
				return
	
	else:
		for move in current_black_moves:
			var dest = get_destination_from_notation(move)
			
			# TODO:: Pawn promotion?
			
			if dest[0] == row && dest[1] == col:
				resolve_move(move)
				return
	
func resolve_move(move: String) -> void:
	var dest = get_destination_from_notation(move)
	var row_dest = dest[0]
	var col_dest = dest[1]
	var tile_dest = get_tile(row_dest, col_dest)
	
	var start = get_start_from_notation(move)
	var row_st = start[0]
	var col_st = start[1]
	var tile_st = get_tile(row_st, col_st)
	
	# Check if move is en passant
	if move.contains(":"):
		var pawn_to_remove = get_tile_piece(get_tile(row_st, col_dest))
		pawn_to_remove.queue_free()
			
		var selected_piece: Object = get_tile_piece(get_tile(row_st, col_st))
		selected_piece.first_move = false
		selected_piece.reparent(tile_dest, false)
		hide_move_here_indicators()		
		
	# Check if move is kingside castle
	elif move == "0-0":
		if (white_to_move):
			var rook_tile = get_tile(1,8)
			var rook = get_tile_piece(rook_tile)
			var rook_dest_tile = get_tile(1,6)
			
			var king_tile = get_tile(1,5)
			var king = get_tile_piece(king_tile)
			var king_dest_tile = get_tile(1,7)
			
			rook.first_move = false
			king.first_move = false
			king.reparent(king_dest_tile, false)
			rook.reparent(rook_dest_tile, false)
			hide_move_here_indicators()
		else:
			var rook_tile = get_tile(8,8)
			var rook = get_tile_piece(rook_tile)
			var rook_dest_tile = get_tile(8,6)
			
			var king_tile = get_tile(8,5)
			var king = get_tile_piece(king_tile)
			var king_dest_tile = get_tile(8,7)
			
			rook.first_move = false
			king.first_move = false
			king.reparent(king_dest_tile, false)
			rook.reparent(rook_dest_tile, false)
			hide_move_here_indicators()
		
	# Check if move is queenside castle
	elif move == "0-0-0":
		if (white_to_move):
			var rook_tile = get_tile(1,1)
			var rook = get_tile_piece(rook_tile)
			var rook_dest_tile = get_tile(1,4)
			
			var king_tile = get_tile(1,5)
			var king = get_tile_piece(king_tile)
			var king_dest_tile = get_tile(1,3)
			
			rook.first_move = false
			king.first_move = false
			king.reparent(king_dest_tile, false)
			rook.reparent(rook_dest_tile, false)
			hide_move_here_indicators()
		else:
			var rook_tile = get_tile(8,1)
			var rook = get_tile_piece(rook_tile)
			var rook_dest_tile = get_tile(8,4)
			
			var king_tile = get_tile(8,5)
			var king = get_tile_piece(king_tile)
			var king_dest_tile = get_tile(8,3)
			
			rook.first_move = false
			king.first_move = false
			king.reparent(king_dest_tile, false)
			rook.reparent(rook_dest_tile, false)
			hide_move_here_indicators()
		
	#Otherwise it's a normal move
	else:
		# Check if piece already at destination, if so remove
		var piece_at_dest: Object = get_tile_piece(get_tile(row_dest, col_dest))
		if piece_at_dest != null:
			piece_at_dest.queue_free()
			
		# Move selected piece to destination
		var selected_piece: Object = get_tile_piece(get_tile(row_st, col_st))
		selected_piece.first_move = false
		selected_piece.reparent(tile_dest, false)
		hide_move_here_indicators()
		
		# TODO:: Pawn promotion?
	
	move_log.append(move)
	
	if white_to_move:
		white_move_log.append(move)
	else:
		black_move_log.append(move)
	white_to_move = !white_to_move
		



## POSSIBLE MOVES
func compute_white_pawn_moves(row: int, column: int) -> Array:
	var moves = []
	
	# Check if pawn is actually there:
	var pawn = get_tile_piece(get_tile(row, column))
	if pawn == null || !pawn.name.to_lower().contains("whitepawn"):
		return moves
	
	# Moving ahead - check if blocked:
	var piece_ahead = get_tile_piece(get_tile(row+1, column))
	if piece_ahead == null:
		# Are we hitting the end and promoting?
		if row + 1 == 8:
			moves.append(str(row, get_column_letter(column), row+1, get_column_letter(column), "=", "Q")) # Promote to queen
			moves.append(str(row, get_column_letter(column), row+1, get_column_letter(column), "=", "N")) # Promote to knight
			moves.append(str(row, get_column_letter(column), row+1, get_column_letter(column), "=", "R")) # Promote to rook
			moves.append(str(row, get_column_letter(column), row+1, get_column_letter(column), "=", "B")) # Promote to bishop
			
		# Is this the first move for the pawn
		elif pawn.first_move:
			var piece_2_ahead = get_tile_piece(get_tile(row+2, column))
			if piece_2_ahead == null:
				moves.append(str(row, get_column_letter(column), row+1, get_column_letter(column)))
				moves.append(str(row, get_column_letter(column), row+2, get_column_letter(column)))
			else:
				moves.append(str(row, get_column_letter(column), row+1, get_column_letter(column)))
				
		# Otherwise just move ahead
		else:
			moves.append(str(row, get_column_letter(column), row+1, get_column_letter(column)))
			
	# Capturing left
	if (column > 1):
		var piece_left = get_tile_piece(get_tile(row+1, column-1))
		if piece_left != null  && piece_left.name.to_lower().contains("black"):
			# Are we capturing into promote?
			if row + 1 == 8:
				moves.append(str(row, get_column_letter(column), "x", row+1, get_column_letter(column-1), "=", "Q")) # Promote to queen
				moves.append(str(row, get_column_letter(column), "x", row+1, get_column_letter(column-1), "=", "N")) # Promote to knight
				moves.append(str(row, get_column_letter(column), "x", row+1, get_column_letter(column-1), "=", "R")) # Promote to rook
				moves.append(str(row, get_column_letter(column), "x", row+1, get_column_letter(column-1), "=", "B")) # Promote to bishop
			else:
				moves.append(str(row, get_column_letter(column), "x", row+1, get_column_letter(column-1)))
				
	# Capturing right
	if (column < 8):
		var piece_right = get_tile_piece(get_tile(row+1, column+1))
		if piece_right != null && piece_right.name.to_lower().contains("black"):
			# Are we capturing into promote?
			if row + 1 == 8:
				moves.append(str(row, get_column_letter(column), "x", row+1, get_column_letter(column+1), "=", "Q")) # Promote to queen
				moves.append(str(row, get_column_letter(column), "x", row+1, get_column_letter(column+1), "=", "N")) # Promote to knight
				moves.append(str(row, get_column_letter(column), "x", row+1, get_column_letter(column+1), "=", "R")) # Promote to rook
				moves.append(str(row, get_column_letter(column), "x", row+1, get_column_letter(column+1), "=", "B")) # Promote to bishop
			else:
				moves.append(str(row, get_column_letter(column), "x", row+1, get_column_letter(column+1)))
				
	# En Passant - left
	if (column > 1):
		var piece_left = get_tile_piece(get_tile(row, column-1))
		if piece_left != null && piece_left.name.to_lower().contains("blackpawn"):
			var last_move = move_log[-1]
			var last_move_start = get_start_from_notation(last_move)
			var last_move_dest = get_destination_from_notation(last_move)
			if (row == last_move_dest[0] && column-1 == last_move_dest[1]) && (last_move_start[0] - last_move_dest[0] == 2):
				moves.append(str(row, get_column_letter(column), ":", row+1, get_column_letter(column-1)))
	
	# En Passant - right
	if (column < 8):
		var piece_right = get_tile_piece(get_tile(row, column+1))
		if piece_right != null && piece_right.name.to_lower().contains("blackpawn"):
			var last_move = move_log[-1]
			var last_move_start = get_start_from_notation(last_move)
			var last_move_dest = get_destination_from_notation(last_move)
			if (row == last_move_dest[0] && column+1 == last_move_dest[1]) && (last_move_start[0] - last_move_dest[0] == 2):
				moves.append(str(row, get_column_letter(column), ":", row+1, get_column_letter(column+1)))
	
		
	return moves
	
	
func compute_black_pawn_moves(row: int, column: int) -> Array:
	var moves = []
	
	# Check if pawn is actually there:
	var pawn = get_tile_piece(get_tile(row, column))
	if pawn == null || !pawn.name.to_lower().contains("blackpawn"):
		return moves
	
	# Moving ahead - check if blocked:
	var piece_ahead = get_tile_piece(get_tile(row-1, column))
	if piece_ahead == null:
		# Are we hitting the end and promoting?
		if row - 1 == 1:
			moves.append(str(row, get_column_letter(column), row-1, get_column_letter(column), "=", "Q")) # Promote to queen
			moves.append(str(row, get_column_letter(column), row-1, get_column_letter(column), "=", "N")) # Promote to knight
			moves.append(str(row, get_column_letter(column), row-1, get_column_letter(column), "=", "R")) # Promote to rook
			moves.append(str(row, get_column_letter(column), row-1, get_column_letter(column), "=", "B")) # Promote to bishop
			
		# Is this the first move for the pawn
		elif pawn.first_move:
			var piece_2_ahead = get_tile_piece(get_tile(row-2, column))
			if piece_2_ahead == null:
				moves.append(str(row, get_column_letter(column), row-1, get_column_letter(column)))
				moves.append(str(row, get_column_letter(column), row-2, get_column_letter(column)))
			else:
				moves.append(str(row, get_column_letter(column), row-1, get_column_letter(column)))
				
		# Otherwise just move ahead
		else:
			moves.append(str(row, get_column_letter(column), row-1, get_column_letter(column)))
			
	# Capturing left
	if (column > 1):
		var piece_left = get_tile_piece(get_tile(row-1, column-1))
		if piece_left != null && piece_left.name.to_lower().contains("white"):
			# Are we capturing into promote?
			if row + 1 == 8:
				moves.append(str(row, get_column_letter(column), "x", row-1, get_column_letter(column-1), "=", "Q")) # Promote to queen
				moves.append(str(row, get_column_letter(column), "x", row-1, get_column_letter(column-1), "=", "N")) # Promote to knight
				moves.append(str(row, get_column_letter(column), "x", row-1, get_column_letter(column-1), "=", "R")) # Promote to rook
				moves.append(str(row, get_column_letter(column), "x", row-1, get_column_letter(column-1), "=", "B")) # Promote to bishop
			else:
				moves.append(str(row, get_column_letter(column), "x", row-1, get_column_letter(column-1)))
				
	# Capturing right
	if (column < 8):
		var piece_right = get_tile_piece(get_tile(row-1, column+1))
		if piece_right != null && piece_right.name.to_lower().contains("white"):
			# Are we capturing into promote?
			if row + 1 == 8:
				moves.append(str(row, get_column_letter(column), "x", row-1, get_column_letter(column+1), "=", "Q")) # Promote to queen
				moves.append(str(row, get_column_letter(column), "x", row-1, get_column_letter(column+1), "=", "N")) # Promote to knight
				moves.append(str(row, get_column_letter(column), "x", row-1, get_column_letter(column+1), "=", "R")) # Promote to rook
				moves.append(str(row, get_column_letter(column), "x", row-1, get_column_letter(column+1), "=", "B")) # Promote to bishop
			else:
				moves.append(str(row, get_column_letter(column), "x", row-1, get_column_letter(column+1)))
		
	# En Passant - left
	if (column > 1):
		var piece_left = get_tile_piece(get_tile(row, column-1))
		if piece_left != null && piece_left.name.to_lower().contains("whitepawn"):
			var last_move = move_log[-1]
			var last_move_start = get_start_from_notation(last_move)
			var last_move_dest = get_destination_from_notation(last_move)
			if (row == last_move_dest[0] && column-1 == last_move_dest[1]) && (last_move_dest[0] - last_move_start[0] == 2):
				moves.append(str(row, get_column_letter(column), ":", row-1, get_column_letter(column-1)))
	
	# En Passant - right
	if (column < 8):
		var piece_right = get_tile_piece(get_tile(row, column+1))
		if piece_right != null && piece_right.name.to_lower().contains("whitepawn"):
			var last_move = move_log[-1]
			var last_move_start = get_start_from_notation(last_move)
			var last_move_dest = get_destination_from_notation(last_move)
			if (row == last_move_dest[0] && column+1 == last_move_dest[1]) && (last_move_dest[0] - last_move_start[0] == 2):
				moves.append(str(row, get_column_letter(column), ":", row-1, get_column_letter(column+1)))	
	
	return moves
	
func compute_white_king_moves(row: int, column: int) -> Array:
	var moves = []
	
	# Check if king is actually there:
	var king = get_tile_piece(get_tile(row, column))
	if king == null || !king.name.to_lower().contains("whiteking"):
		return moves
	
	# Up-left
	if (row < 8 && column > 1):
		# Is there a piece there?
		var piece = get_tile_piece(get_tile(row+1, column-1))
		if piece == null:
			moves.append(str("K", row, get_column_letter(column), row+1, get_column_letter(column-1)))
		else:
			# If enemy piece, capture
			if piece.name.to_lower().contains("black"):
				moves.append(str("K", row, get_column_letter(column), "x", row+1, get_column_letter(column-1)))
	
	# Up
	if (row < 8):
		# Is there a piece there?
		var piece = get_tile_piece(get_tile(row+1, column))
		if piece == null:
			moves.append(str("K", row, get_column_letter(column), row+1, get_column_letter(column)))
		else:
			# If enemy piece, capture
			if piece.name.to_lower().contains("black"):
				moves.append(str("K", row, get_column_letter(column), "x", row+1, get_column_letter(column)))
	
	# Up-right
	if (row < 8 && column < 8):
		# Is there a piece there?
		var piece = get_tile_piece(get_tile(row+1, column+1))
		if piece == null:
			moves.append(str("K", row, get_column_letter(column), row+1, get_column_letter(column+1)))
		else:
			# If enemy piece, capture
			if piece.name.to_lower().contains("black"):
				moves.append(str("K", row, get_column_letter(column), "x", row+1,get_column_letter(column+1)))
	
	# Right
	if (column < 8):
		# Is there a piece there?
		var piece = get_tile_piece(get_tile(row, column+1))
		if piece == null:
			moves.append(str("K", row, get_column_letter(column), row, get_column_letter(column+1)))
		else:
			# If enemy piece, capture
			if piece.name.to_lower().contains("black"):
				moves.append(str("K", row, get_column_letter(column), "x", row, get_column_letter(column+1)))
	
	# Right-down
	if (row > 1 && column < 8):
		# Is there a piece there?
		var piece = get_tile_piece(get_tile(row-1, column+1))
		if piece == null:
			moves.append(str("K", row, get_column_letter(column), row-1, get_column_letter(column+1)))
		else:
			# If enemy piece, capture
			if piece.name.to_lower().contains("black"):
				moves.append(str("K", row, get_column_letter(column), "x", row-1,get_column_letter(column+1)))
	
	# Down
	if (row > 1):
		# Is there a piece there?
		var piece = get_tile_piece(get_tile(row-1, column))
		if piece == null:
			moves.append(str("K", row, get_column_letter(column), row-1, get_column_letter(column)))
		else:
			# If enemy piece, capture
			if piece.name.to_lower().contains("black"):
				moves.append(str("K", row, get_column_letter(column), "x", row-1, get_column_letter(column)))
	
	# Down-left
	if (row > 1 && column > 1):
		# Is there a piece there?
		var piece = get_tile_piece(get_tile(row-1, column-1))
		if piece == null:
			moves.append(str("K", row, get_column_letter(column), row-1, get_column_letter(column-1)))
		else:
			# If enemy piece, capture
			if piece.name.to_lower().contains("black"):
				moves.append(str("K", row, get_column_letter(column), "x", row-1, get_column_letter(column-1)))
	
	# Left
	if (column > 1):
		# Is there a piece there?
		var piece = get_tile_piece(get_tile(row, column-1))
		if piece == null:
			moves.append(str("K", row, get_column_letter(column), row, get_column_letter(column-1)))
		else:
			# If enemy piece, capture
			if piece.name.to_lower().contains("black"):
				moves.append(str("K", row, get_column_letter(column), "x", row, get_column_letter(column-1)))
				
	# Castling queenside
	if king.first_move:
		var left_rook = get_tile_piece(get_tile(1, 1))
		if left_rook != null && left_rook.name == "WhiteRook" && left_rook.first_move:
			var empty = true
			for i in range(2,5,1):
				var piece = get_tile_piece(get_tile(1,i))
				if piece != null:
					empty = false
			if empty:
				castleFromKing = true
				moves.append("0-0-0")
	
	# Castling kingside
	if king.first_move:
		var right_rook = get_tile_piece(get_tile(1, 8))
		if right_rook != null && right_rook.name == "WhiteRook" && right_rook.first_move:
			var empty = true
			for i in range(6,8,1):
				var piece = get_tile_piece(get_tile(1,i))
				if piece != null:
					empty = false
			if empty:
				castleFromKing = true
				moves.append("0-0")
				
	return moves
	
func compute_black_king_moves(row: int, column: int) -> Array:
	var moves = []
	
	# Check if king is actually there:
	var king = get_tile_piece(get_tile(row, column))
	if king == null || !king.name.to_lower().contains("blackking"):
		return moves
	
	# Up-left
	if (row < 8 && column > 1):
		# Is there a piece there?
		var piece = get_tile_piece(get_tile(row+1, column-1))
		if piece == null:
			moves.append(str("K", row, get_column_letter(column), row+1, get_column_letter(column-1)))
		else:
			# If enemy piece, capture
			if piece.name.to_lower().contains("white"):
				moves.append(str("K", row, get_column_letter(column), "x", row+1, get_column_letter(column-1)))
	
	# Up
	if (row < 8):
		# Is there a piece there?
		var piece = get_tile_piece(get_tile(row+1, column))
		if piece == null:
			moves.append(str("K", row, get_column_letter(column), row+1, get_column_letter(column)))
		else:
			# If enemy piece, capture
			if piece.name.to_lower().contains("white"):
				moves.append(str("K", row, get_column_letter(column), "x", row+1, get_column_letter(column)))
	
	# Up-right
	if (row < 8 && column < 8):
		# Is there a piece there?
		var piece = get_tile_piece(get_tile(row+1, column+1))
		if piece == null:
			moves.append(str("K", row, get_column_letter(column), row+1, get_column_letter(column+1)))
		else:
			# If enemy piece, capture
			if piece.name.to_lower().contains("white"):
				moves.append(str("K", row, get_column_letter(column), "x", row+1, get_column_letter(column+1)))
	
	# Right
	if (column < 8):
		# Is there a piece there?
		var piece = get_tile_piece(get_tile(row, column+1))
		if piece == null:
			moves.append(str("K", row, get_column_letter(column), row, get_column_letter(column+1)))
		else:
			# If enemy piece, capture
			if piece.name.to_lower().contains("white"):
				moves.append(str("K", row, get_column_letter(column), "x", row, get_column_letter(column+1)))
	
	# Right-down
	if (row > 1 && column < 8):
		# Is there a piece there?
		var piece = get_tile_piece(get_tile(row-1, column+1))
		if piece == null:
			moves.append(str("K", row, get_column_letter(column), row-1, get_column_letter(column+1)))
		else:
			# If enemy piece, capture
			if piece.name.to_lower().contains("white"):
				moves.append(str("K", row, get_column_letter(column), "x", row-1, get_column_letter(column+1)))
	
	# Down
	if (row > 1):
		# Is there a piece there?
		var piece = get_tile_piece(get_tile(row-1, column))
		if piece == null:
			moves.append(str("K", row, get_column_letter(column), row-1, get_column_letter(column)))
		else:
			# If enemy piece, capture
			if piece.name.to_lower().contains("white"):
				moves.append(str("K", row, get_column_letter(column), "x", row-1, get_column_letter(column)))
	
	# Down-left
	if (row > 1 && column > 1):
		# Is there a piece there?
		var piece = get_tile_piece(get_tile(row-1, column-1))
		if piece == null:
			moves.append(str("K", row, get_column_letter(column), row-1, get_column_letter(column-1)))
		else:
			# If enemy piece, capture
			if piece.name.to_lower().contains("white"):
				moves.append(str("K", row, get_column_letter(column), "x", row-1, get_column_letter(column-1)))
	
	# Left
	if (column > 1):
		# Is there a piece there?
		var piece = get_tile_piece(get_tile(row, column-1))
		if piece == null:
			moves.append(str("K", row, get_column_letter(column), row, get_column_letter(column-1)))
		else:
			# If enemy piece, capture
			if piece.name.to_lower().contains("white"):
				moves.append(str("K", row, get_column_letter(column), "x", row, get_column_letter(column-1)))
				
	# Castling queenside
	if king.first_move:
		var left_rook = get_tile_piece(get_tile(8, 1))
		if left_rook != null && left_rook.name == "BlackRook" && left_rook.first_move:
			var empty = true
			for i in range(2,5,1):
				var piece = get_tile_piece(get_tile(8,i))
				if piece != null:
					empty = false
			if empty:
				castleFromKing = true
				moves.append("0-0-0")
	
	# Castling kingside
	if king.first_move:
		var right_rook = get_tile_piece(get_tile(8, 8))
		if right_rook != null && right_rook.name == "BlackRook" && right_rook.first_move:
			var empty = true
			for i in range(6,8,1):
				var piece = get_tile_piece(get_tile(8,i))
				if piece != null:
					empty = false
			if empty:
				castleFromKing = true
				moves.append("0-0")
				
	return moves
	
func compute_white_rook_moves(row: int, column: int) -> Array:
	var moves = []
	
	# Check if rook or queen is actually there:
	var rook = get_tile_piece(get_tile(row, column))
	if rook == null || !(rook.name.to_lower().contains("whiterook") || rook.name.to_lower().contains("whitequeen")):
		return moves
		
	var symbol = "R"
	if rook.name.to_lower().contains("queen"):
		symbol = "Q"
		
	# Move up
	if (row < 8):
		var row_iter = row + 1
		var piece_ahead = get_tile_piece(get_tile(row_iter, column))
		
		while row_iter <= 8 && piece_ahead == null:
			moves.append(str(symbol, row, get_column_letter(column), row_iter, get_column_letter(column)))
			row_iter += 1
			if (row_iter <= 8):
				piece_ahead = get_tile_piece(get_tile(row_iter, column))
		
		if row_iter <= 8 && piece_ahead != null && piece_ahead.name.to_lower().contains("black"):
			moves.append(str(symbol, row, get_column_letter(column), "x", row_iter, get_column_letter(column)))
	
	# Move right
	if (column < 8):
		var col_iter = column + 1
		var piece_ahead = get_tile_piece(get_tile(row, col_iter))
		
		while col_iter <= 8 && piece_ahead == null:
			moves.append(str(symbol, row, get_column_letter(column), row, get_column_letter(col_iter)))
			col_iter += 1
			if (col_iter <= 8):
				piece_ahead = get_tile_piece(get_tile(row, col_iter))
		
		if col_iter <= 8 && piece_ahead != null && piece_ahead.name.to_lower().contains("black"):
			moves.append(str(symbol, row, get_column_letter(column), "x", row, get_column_letter(col_iter)))
	
	# Move down
	if (row > 1):
		var row_iter = row - 1
		var piece_ahead = get_tile_piece(get_tile(row_iter, column))
		
		while row_iter >= 1 && piece_ahead == null:
			moves.append(str(symbol, row, get_column_letter(column), row_iter, get_column_letter(column)))
			row_iter -= 1
			if (row_iter >= 1):
				piece_ahead = get_tile_piece(get_tile(row_iter, column))
		
		if row_iter >= 1 && piece_ahead != null && piece_ahead.name.to_lower().contains("black"):
			moves.append(str(symbol, row, get_column_letter(column), "x", row_iter, get_column_letter(column)))
	
	# Move left
	if (column > 1):
		var col_iter = column - 1
		var piece_ahead = get_tile_piece(get_tile(row, col_iter))
		
		while col_iter >= 1 && piece_ahead == null:
			moves.append(str(symbol, row, get_column_letter(column), row, get_column_letter(col_iter)))
			col_iter -= 1
			if (col_iter >= 1):
				piece_ahead = get_tile_piece(get_tile(row, col_iter))
		
		if col_iter >= 1 && piece_ahead != null && piece_ahead.name.to_lower().contains("black"):
			moves.append(str(symbol, row, get_column_letter(column), "x", row, get_column_letter(col_iter)))
	
	# Castling
	if rook.first_move && symbol != "Q":
		var king = get_tile_piece(get_tile(1, 5))
		if king != null && king.name == "WhiteKing" && king.first_move:
			# Left rook
			if column == 1:
				var empty = true
				for i in range(2,5,1):
					var piece = get_tile_piece(get_tile(1, i))
					if piece != null:
						empty = false
				if empty:
					castleFromKing = false
					moves.append("0-0-0")
			# Right rook
			else:
				var empty = true
				for i in range(6,8,1):
					var piece = get_tile_piece(get_tile(1, i))
					if piece != null:
						empty = false
				if empty:
					castleFromKing = false
					moves.append("0-0")
	
	return moves
	
func compute_black_rook_moves(row: int, column: int) -> Array:
	var moves = []
	
	# Check if rook or queen is actually there:
	var rook = get_tile_piece(get_tile(row, column))
	if rook == null || !(rook.name.to_lower().contains("blackrook") || rook.name.to_lower().contains("blackqueen")):
		return moves
		
	var symbol = "R"
	if rook.name.to_lower().contains("queen"):
		symbol = "Q"
		
	# Move up
	if (row < 8):
		var row_iter = row + 1
		var piece_ahead = get_tile_piece(get_tile(row_iter, column))
		
		while row_iter <= 8 && piece_ahead == null:
			moves.append(str(symbol, row, get_column_letter(column), row_iter, get_column_letter(column)))
			row_iter += 1
			if (row_iter <= 8):
				piece_ahead = get_tile_piece(get_tile(row_iter, column))
		
		if row_iter <= 8 && piece_ahead != null && piece_ahead.name.to_lower().contains("white"):
			moves.append(str(symbol, row, get_column_letter(column), "x", row_iter, get_column_letter(column)))
	
	# Move right
	if (column < 8):
		var col_iter = column + 1
		var piece_ahead = get_tile_piece(get_tile(row, col_iter))
		
		while col_iter <= 8 && piece_ahead == null:
			moves.append(str(symbol, row, get_column_letter(column), row, get_column_letter(col_iter)))
			col_iter += 1
			if (col_iter <= 8):
				piece_ahead = get_tile_piece(get_tile(row, col_iter))
		
		if col_iter <= 8 && piece_ahead != null && piece_ahead.name.to_lower().contains("white"):
			moves.append(str(symbol, row, get_column_letter(column), "x", row, get_column_letter(col_iter)))
	
	# Move down
	if (row > 1):
		var row_iter = row - 1
		var piece_ahead = get_tile_piece(get_tile(row_iter, column))
		
		while row_iter >= 1 && piece_ahead == null:
			moves.append(str(symbol, row, get_column_letter(column), row_iter, get_column_letter(column)))
			row_iter -= 1
			if (row_iter >= 1):
				piece_ahead = get_tile_piece(get_tile(row_iter, column))
		
		if row_iter >= 1 && piece_ahead != null && piece_ahead.name.to_lower().contains("white"):
			moves.append(str(symbol, row, get_column_letter(column), "x", row_iter, get_column_letter(column)))
	
	# Move left
	if (column > 1):
		var col_iter = column - 1
		var piece_ahead = get_tile_piece(get_tile(row, col_iter))
		
		while col_iter >= 1 && piece_ahead == null:
			moves.append(str(symbol, row, get_column_letter(column), row, get_column_letter(col_iter)))
			col_iter -= 1
			if (col_iter >= 1):
				piece_ahead = get_tile_piece(get_tile(row, col_iter))
		
		if col_iter >= 1 && piece_ahead != null && piece_ahead.name.to_lower().contains("white"):
			moves.append(str(symbol, row, get_column_letter(column), "x", row, get_column_letter(col_iter)))
	
	# Castling
	if rook.first_move && symbol != "Q":
		var king = get_tile_piece(get_tile(1, 5))
		if king != null && king.name == "BlackKing" && king.first_move:
			# Left rook
			if column == 1:
				var empty = true
				for i in range(2,5,1):
					var piece = get_tile_piece(get_tile(8, i))
					if piece != null:
						empty = false
				if empty:
					castleFromKing = false
					moves.append("0-0-0")
			# Right rook
			else:
				var empty = true
				for i in range(6,8,1):
					var piece = get_tile_piece(get_tile(8, i))
					if piece != null:
						empty = false
				if empty:
					castleFromKing = false
					moves.append("0-0")
	
	return moves
	
func compute_white_bishop_moves(row: int, column: int) -> Array:
	var moves = []
	# Check if bishop or queen is actually there:
	var bishop = get_tile_piece(get_tile(row, column))
	if bishop == null || !(bishop.name.to_lower().contains("whitebishop") || bishop.name.to_lower().contains("whitequeen")):
		return moves
		
	var symbol = "B"
	if bishop.name.to_lower().contains("queen"):
		symbol = "Q"
		
	# Move up-left
	if (row < 8 && column > 1):
		var row_iter = row + 1
		var col_iter = column - 1
		var piece_ahead = get_tile_piece(get_tile(row_iter, col_iter))
		
		while row <= 8 && col_iter >= 1 && piece_ahead == null:
			moves.append(str(symbol, row, get_column_letter(column), row_iter, get_column_letter(col_iter)))
			row_iter += 1
			col_iter -= 1
			if (row_iter <= 8 && col_iter >= 1):
				piece_ahead = get_tile_piece(get_tile(row_iter, col_iter))
				
		if row_iter <= 8 && col_iter >= 1 && piece_ahead != null && piece_ahead.name.to_lower().contains("black"):
			moves.append(str(symbol, row, get_column_letter(column), "x", row_iter, get_column_letter(col_iter)))
	
	# Move up-right
	if (row < 8 && column < 8):
		var row_iter = row + 1
		var col_iter = column + 1
		var piece_ahead = get_tile_piece(get_tile(row_iter, col_iter))
		
		while row_iter <= 8 && col_iter <= 8 && piece_ahead == null:
			moves.append(str(symbol, row, get_column_letter(column), row_iter, get_column_letter(col_iter)))
			row_iter += 1
			col_iter += 1
			if (row_iter <= 8 && col_iter <= 8):
				piece_ahead = get_tile_piece(get_tile(row_iter, col_iter))
				
		if row_iter <= 8 && col_iter <= 8 && piece_ahead != null && piece_ahead.name.to_lower().contains("black"):
			moves.append(str(symbol, row, get_column_letter(column), "x", row_iter, get_column_letter(col_iter)))
	
	# Move down-right
	if (row > 1 && column < 8):
		var row_iter = row - 1
		var col_iter = column + 1
		var piece_ahead = get_tile_piece(get_tile(row_iter, col_iter))
		
		while row_iter >= 1 && col_iter <= 8 && piece_ahead == null:
			moves.append(str(symbol, row, get_column_letter(column), row_iter, get_column_letter(col_iter)))
			row_iter -= 1
			col_iter += 1
			if (row_iter >= 1 && col_iter <= 8):
				piece_ahead = get_tile_piece(get_tile(row_iter, col_iter))
				
		if row_iter >= 1 && col_iter <= 8 && piece_ahead != null && piece_ahead.name.to_lower().contains("black"):
			moves.append(str(symbol, row, get_column_letter(column), "x", row_iter, get_column_letter(col_iter)))
	
	# Move down-left
	if (row > 1 && column > 1):
		var row_iter = row - 1
		var col_iter = column - 1
		var piece_ahead = get_tile_piece(get_tile(row_iter, col_iter))
		
		while row_iter >= 1 && col_iter >= 1 && piece_ahead == null:
			moves.append(str(symbol, row, get_column_letter(column), row_iter, get_column_letter(col_iter)))
			row_iter -= 1
			col_iter -= 1
			if (row_iter >= 1 && col_iter >= 1):
				piece_ahead = get_tile_piece(get_tile(row_iter, col_iter))
				
		if row_iter >= 1 && col_iter >= 1 && piece_ahead != null && piece_ahead.name.to_lower().contains("black"):
			moves.append(str(symbol, row, get_column_letter(column), "x", row_iter, get_column_letter(col_iter)))
	
	return moves
	
func compute_black_bishop_moves(row: int, column: int) -> Array:
	var moves = []
	
	# Check if bishop or queen is actually there:
	var bishop = get_tile_piece(get_tile(row, column))
	if bishop == null || !(bishop.name.to_lower().contains("blackbishop") || bishop.name.to_lower().contains("blackqueen")):
		return moves
		
	var symbol = "B"
	if bishop.name.to_lower().contains("queen"):
		symbol = "Q"
		
	# Move up-left
	if (row < 8 && column > 1):
		var row_iter = row + 1
		var col_iter = column - 1
		var piece_ahead = get_tile_piece(get_tile(row_iter, col_iter))
		
		while row_iter <= 8 && col_iter >= 1 && piece_ahead == null:
			moves.append(str(symbol, row, get_column_letter(column), row_iter, get_column_letter(col_iter)))
			row_iter += 1
			col_iter -= 1
			if (row_iter <= 8 && col_iter >= 1):
				piece_ahead = get_tile_piece(get_tile(row_iter, col_iter))
				
		if row_iter <= 8 && col_iter >= 1 && piece_ahead != null && piece_ahead.name.to_lower().contains("white"):
			moves.append(str(symbol, row, get_column_letter(column), "x", row_iter, get_column_letter(col_iter)))
	
	# Move up-right
	if (row < 8 && column < 8):
		var row_iter = row + 1
		var col_iter = column + 1
		var piece_ahead = get_tile_piece(get_tile(row_iter, col_iter))
		
		while row_iter <= 8 && col_iter <= 8 && piece_ahead == null:
			moves.append(str(symbol, row, get_column_letter(column), row_iter, get_column_letter(col_iter)))
			row_iter += 1
			col_iter += 1
			if (row_iter <= 8 && col_iter <= 8):
				piece_ahead = get_tile_piece(get_tile(row_iter, col_iter))
				
		if row_iter <= 8 && col_iter <= 8 && piece_ahead != null && piece_ahead.name.to_lower().contains("white"):
			moves.append(str(symbol, row, get_column_letter(column), "x", row_iter, get_column_letter(col_iter)))
	
	# Move down-right
	if (row > 1 && column < 8):
		var row_iter = row - 1
		var col_iter = column + 1
		var piece_ahead = get_tile_piece(get_tile(row_iter, col_iter))
		
		while row_iter >= 1 && col_iter <= 8 && piece_ahead == null:
			moves.append(str(symbol, row, get_column_letter(column), row_iter, get_column_letter(col_iter)))
			row -= 1
			col_iter += 1
			if (row_iter >= 1 && col_iter <= 8):
				piece_ahead = get_tile_piece(get_tile(row_iter, col_iter))
				
		if row_iter >= 1 && col_iter <= 8 && piece_ahead != null && piece_ahead.name.to_lower().contains("white"):
			moves.append(str(symbol, row, get_column_letter(column), "x", row_iter, get_column_letter(col_iter)))
	
	# Move down-left
	if (row > 1 && column > 1):
		var row_iter = row - 1
		var col_iter = column - 1
		var piece_ahead = get_tile_piece(get_tile(row_iter, col_iter))
		
		while row_iter >= 1 && col_iter >= 1 && piece_ahead == null:
			moves.append(str(symbol, row, get_column_letter(column), row_iter, get_column_letter(col_iter)))
			row -= 1
			col_iter -= 1
			if (row_iter >= 1 && col_iter >= 1):
				piece_ahead = get_tile_piece(get_tile(row_iter, col_iter))
				
		if row_iter >= 1 && col_iter >= 1 && piece_ahead != null && piece_ahead.name.to_lower().contains("white"):
			moves.append(str(symbol, row, get_column_letter(column), "x", row_iter, get_column_letter(col_iter)))
	
	return moves
	
func compute_white_queen_moves(row: int, column: int) -> Array:
	var moves = []
	
	# Check if queen is actually there:
	var queen = get_tile_piece(get_tile(row, column))
	if queen == null || !queen.name.to_lower().contains("whitequeen"):
		return moves
	
	var bishop_moves = compute_white_bishop_moves(row, column)
	var rook_moves = compute_white_rook_moves(row, column)
	
	moves.append_array(bishop_moves)
	moves.append_array(rook_moves)
	 
	return moves
	
func compute_black_queen_moves(row: int, column: int) -> Array:
	var moves = []
	
	# Check if queen is actually there:
	var queen = get_tile_piece(get_tile(row, column))
	if queen == null || !queen.name.to_lower().contains("blackqueen"):
		return moves
	
	var bishop_moves = compute_black_bishop_moves(row, column)
	var rook_moves = compute_black_rook_moves(row, column)
	
	moves.append_array(bishop_moves)
	moves.append_array(rook_moves)
	
	return moves
	
func compute_white_knight_moves(row: int, column: int) -> Array:
	var moves = []
	
	# Check if knight is actually there:
	var knight = get_tile_piece(get_tile(row, column))
	if knight == null || !knight.name.to_lower().contains("whiteknight"):
		return moves
	
	var possible_row_moves = [+2, +2, +1, -1, -2, -2, -1, +1]
	var possible_col_moves = [-1, +1, +2, +2, +1, -1, -2, -2]
	
	# Loop over possible moves, check which are within bounds, and/or conflict other pieces
	for i in range(possible_col_moves.size()):
		var row_move = possible_row_moves[i]
		var col_move = possible_col_moves[i]
		
		if (row + row_move) >= 1 && (row + row_move) <= 8:
			if (column + col_move) >= 1 && (column + col_move) <= 8:
				var piece_at_place = get_tile_piece(get_tile(row + row_move, column + col_move))
				
				if piece_at_place == null:
					moves.append(str("N", row, get_column_letter(column), row + row_move, get_column_letter(column + col_move)))
				elif piece_at_place.name.to_lower().contains("black"):
					moves.append(str("N", row, get_column_letter(column), "x", row + row_move, get_column_letter(column + col_move)))
	
	return moves
	
func compute_black_knight_moves(row: int, column: int) -> Array:
	var moves = []
	
	# Check if knight is actually there:
	var knight = get_tile_piece(get_tile(row, column))
	if knight == null || !knight.name.to_lower().contains("blackknight"):
		return moves
		
	var possible_row_moves = [+2, +2, +1, -1, -2, -2, -1, +1]
	var possible_col_moves = [-1, +1, +2, +2, +1, -1, -2, -2]
	
	# Loop over possible moves, check which are within bounds, and/or conflict other pieces
	for i in range(possible_col_moves.size()):
		var row_move = possible_row_moves[i]
		var col_move = possible_col_moves[i]
		
		if (row + row_move) >= 1 && (row + row_move) <= 8:
			if (column + col_move) >= 1 && (column + col_move) <= 8:
				var piece_at_place = get_tile_piece(get_tile(row + row_move, column + col_move))
				
				if piece_at_place == null:
					moves.append(str("N", row, get_column_letter(column), row + row_move, get_column_letter(column + col_move)))
				elif piece_at_place.name.to_lower().contains("white"):
					moves.append(str("N", row, get_column_letter(column), "x", row + row_move, get_column_letter(column + col_move)))
	
	return moves
