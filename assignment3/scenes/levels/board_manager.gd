extends Node3D

@onready
var board = $"../Board"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
## GENERAL HELPER METHODS
func get_tile(row:int, column: int) -> Object:
	var board_row = board.get_child(row-1)
	var tile = board_row.get_child(column-1)
	return tile
	
func get_tile_piece(tile: Object) -> Object:
	if tile.get_children().size() <= 2:
		return null
	return tile.get_child(2)
	
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
			moves.append(str(row, column, row+1, column))
			
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
			if piece.name.to_lower.contains("black"):
				moves.append(str("K", row, get_column_letter(column), "x", row+1, get_column_letter(column-1)))
	
	# Up
	if (row < 8):
		# Is there a piece there?
		var piece = get_tile_piece(get_tile(row+1, column))
		if piece == null:
			moves.append(str("K", row, get_column_letter(column), row+1, get_column_letter(column)))
		else:
			# If enemy piece, capture
			if piece.name.to_lower.contains("black"):
				moves.append(str("K", row, get_column_letter(column), "x", row+1, get_column_letter(column)))
	
	# Up-right
	if (row < 8 && column < 8):
		# Is there a piece there?
		var piece = get_tile_piece(get_tile(row+1, column+1))
		if piece == null:
			moves.append(str("K", row, get_column_letter(column), row+1, get_column_letter(column+1)))
		else:
			# If enemy piece, capture
			if piece.name.to_lower.contains("black"):
				moves.append(str("K", row, get_column_letter(column), "x", row+1,get_column_letter(column+1)))
	
	# Right
	if (column < 8):
		# Is there a piece there?
		var piece = get_tile_piece(get_tile(row, column+1))
		if piece == null:
			moves.append(str("K", row, get_column_letter(column), row, get_column_letter(column+1)))
		else:
			# If enemy piece, capture
			if piece.name.to_lower.contains("black"):
				moves.append(str("K", row, get_column_letter(column), "x", row, get_column_letter(column+1)))
	
	# Right-down
	if (row > 1 && column < 8):
		# Is there a piece there?
		var piece = get_tile_piece(get_tile(row-1, column+1))
		if piece == null:
			moves.append(str("K", row, get_column_letter(column), row-1, get_column_letter(column+1)))
		else:
			# If enemy piece, capture
			if piece.name.to_lower.contains("black"):
				moves.append(str("K", row, get_column_letter(column), "x", row-1,get_column_letter(column+1)))
	
	# Down
	if (row > 1):
		# Is there a piece there?
		var piece = get_tile_piece(get_tile(row-1, column))
		if piece == null:
			moves.append(str("K", row, get_column_letter(column), row-1, get_column_letter(column)))
		else:
			# If enemy piece, capture
			if piece.name.to_lower.contains("black"):
				moves.append(str("K", row, get_column_letter(column), "x", row-1, get_column_letter(column)))
	
	# Down-left
	if (row > 1 && column > 1):
		# Is there a piece there?
		var piece = get_tile_piece(get_tile(row-1, column-1))
		if piece == null:
			moves.append(str("K", row, get_column_letter(column), row-1, get_column_letter(column-1)))
		else:
			# If enemy piece, capture
			if piece.name.to_lower.contains("black"):
				moves.append(str("K", row, get_column_letter(column), "x", row-1, get_column_letter(column-1)))
	
	# Left
	if (column > 1):
		# Is there a piece there?
		var piece = get_tile_piece(get_tile(row, column-1))
		if piece == null:
			moves.append(str("K", row, get_column_letter(column), row, get_column_letter(column-1)))
		else:
			# If enemy piece, capture
			if piece.name.to_lower.contains("black"):
				moves.append(str("K", row, get_column_letter(column), "x", row, get_column_letter(column-1)))
				
	# TODO:: Castling
				
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
			if piece.name.to_lower.contains("white"):
				moves.append(str("K", row, get_column_letter(column), "x", row+1, get_column_letter(column-1)))
	
	# Up
	if (row < 8):
		# Is there a piece there?
		var piece = get_tile_piece(get_tile(row+1, column))
		if piece == null:
			moves.append(str("K", row, get_column_letter(column), row+1, get_column_letter(column)))
		else:
			# If enemy piece, capture
			if piece.name.to_lower.contains("white"):
				moves.append(str("K", row, get_column_letter(column), "x", row+1, get_column_letter(column)))
	
	# Up-right
	if (row < 8 && column < 8):
		# Is there a piece there?
		var piece = get_tile_piece(get_tile(row+1, column+1))
		if piece == null:
			moves.append(str("K", row, get_column_letter(column), row+1, get_column_letter(column+1)))
		else:
			# If enemy piece, capture
			if piece.name.to_lower.contains("white"):
				moves.append(str("K", row, get_column_letter(column), "x", row+1, get_column_letter(column+1)))
	
	# Right
	if (column < 8):
		# Is there a piece there?
		var piece = get_tile_piece(get_tile(row, column+1))
		if piece == null:
			moves.append(str("K", row, get_column_letter(column), row, get_column_letter(column+1)))
		else:
			# If enemy piece, capture
			if piece.name.to_lower.contains("white"):
				moves.append(str("K", row, get_column_letter(column), "x", row, get_column_letter(column+1)))
	
	# Right-down
	if (row > 1 && column < 8):
		# Is there a piece there?
		var piece = get_tile_piece(get_tile(row-1, column+1))
		if piece == null:
			moves.append(str("K", row, get_column_letter(column), row-1, get_column_letter(column+1)))
		else:
			# If enemy piece, capture
			if piece.name.to_lower.contains("white"):
				moves.append(str("K", row, get_column_letter(column), "x", row-1, get_column_letter(column+1)))
	
	# Down
	if (row > 1):
		# Is there a piece there?
		var piece = get_tile_piece(get_tile(row-1, column))
		if piece == null:
			moves.append(str("K", row, get_column_letter(column), row-1, get_column_letter(column)))
		else:
			# If enemy piece, capture
			if piece.name.to_lower.contains("white"):
				moves.append(str("K", row, get_column_letter(column), "x", row-1, get_column_letter(column)))
	
	# Down-left
	if (row > 1 && column > 1):
		# Is there a piece there?
		var piece = get_tile_piece(get_tile(row-1, column-1))
		if piece == null:
			moves.append(str("K", row, get_column_letter(column), row-1, get_column_letter(column-1)))
		else:
			# If enemy piece, capture
			if piece.name.to_lower.contains("white"):
				moves.append(str("K", row, get_column_letter(column), "x", row-1, get_column_letter(column-1)))
	
	# Left
	if (column > 1):
		# Is there a piece there?
		var piece = get_tile_piece(get_tile(row, column-1))
		if piece == null:
			moves.append(str("K", row, get_column_letter(column), row, get_column_letter(column-1)))
		else:
			# If enemy piece, capture
			if piece.name.to_lower.contains("white"):
				moves.append(str("K", row, get_column_letter(column), "x", row, get_column_letter(column-1)))
				
	# TODO:: Castling
				
	return moves
	
func compute_white_rook_moves(row: int, column: int) -> Array:
	var moves = []
	
	# Check if rook or queen is actually there:
	var rook = get_tile_piece(get_tile(row, column))
	if rook == null || !(rook.name.to_lower().contains("whiterook") || rook.name.to_lower().contains("whitequeen")):
		return moves
		
	# TODO:: Continue from here
	
	return moves
	
func compute_black_rook_moves(row: int, column: int) -> Array:
	var moves = []
	
	# Check if rook or queen is actually there:
	var rook = get_tile_piece(get_tile(row, column))
	if rook == null || !(rook.name.to_lower().contains("blackrook") || rook.name.to_lower().contains("blackqueen")):
		return moves
	
	return moves
	
func compute_white_bishop_moves(row: int, column: int) -> Array:
	var moves = []
	
	# Check if bishop or queen is actually there:
	var bishop = get_tile_piece(get_tile(row, column))
	if bishop == null || !(bishop.name.to_lower().contains("whitebishop") || bishop.name.to_lower().contains("whitequeen")):
		return moves
	
	return moves
	
func compute_black_bishop_moves(row: int, column: int) -> Array:
	var moves = []
	
	# Check if bishop or queen is actually there:
	var bishop = get_tile_piece(get_tile(row, column))
	if bishop == null || !(bishop.name.to_lower().contains("blackbishop") || bishop.name.to_lower().contains("blackqueen")):
		return moves
	
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
	
	return moves
	
func compute_black_knight_moves(row: int, column: int) -> Array:
	var moves = []
	
	# Check if knight is actually there:
	var knight = get_tile_piece(get_tile(row, column))
	if knight == null || !knight.name.to_lower().contains("blackknight"):
		return moves
	
	return moves
