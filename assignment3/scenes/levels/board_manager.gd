extends Node3D

signal player_won

@onready
var board: Object = $"../Board"
@onready
var temp_tile: Object = $"../Board/Temp/temp_tile"

var white_to_move: bool = true
var move_log: Array = []
var white_move_log: Array = []
var black_move_log: Array = []

var current_white_moves: Array = []
var current_black_moves: Array = []

var game_over: bool = false
var can_play: bool = true
var castleFromKing: bool = true

var whitepawn: Object = preload("res://scenes/prefabs/chess_pieces/white/WhitePawn.tscn")
var whiterook: Object = preload("res://scenes/prefabs/chess_pieces/white/WhiteRook.tscn")
var whiteknight: Object = preload("res://scenes/prefabs/chess_pieces/white/WhiteKnight.tscn")
var whitebishop: Object = preload("res://scenes/prefabs/chess_pieces/white/WhiteBishop.tscn")
var whitequeen: Object = preload("res://scenes/prefabs/chess_pieces/white/WhiteQueen.tscn")
var whiteking: Object = preload("res://scenes/prefabs/chess_pieces/white/WhiteKing.tscn")

var blackpawn: Object = preload("res://scenes/prefabs/chess_pieces/black/BlackPawn.tscn")
var blackrook: Object = preload("res://scenes/prefabs/chess_pieces/black/BlackRook.tscn")
var blackknight: Object = preload("res://scenes/prefabs/chess_pieces/black/BlackKnight.tscn")
var blackbishop: Object = preload("res://scenes/prefabs/chess_pieces/black/BlackBishop.tscn")
var blackqueen: Object = preload("res://scenes/prefabs/chess_pieces/black/BlackQueen.tscn")
var blackking: Object = preload("res://scenes/prefabs/chess_pieces/black/BlackKing.tscn")

var puzzleMoveLog: Array = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	enterPuzzleMoveLog()
	hide_move_here_indicators()
	await get_tree().create_timer(1.0).timeout
	reset_board_to_position(puzzleMoveLog)


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
			
#https://chesspuzzle.net/Solution/1028214
func enterPuzzleMoveLog() -> void:
	puzzleMoveLog.append_array(["2e4e", "7c5c"])
	puzzleMoveLog.append_array(["N1g3f", "7d6d"])
	puzzleMoveLog.append_array(["B1f5b", "N8b7d"])
	puzzleMoveLog.append_array(["B5b4a", "N8g6f"])
	puzzleMoveLog.append_array(["0-0", "7g6g"])
	puzzleMoveLog.append_array(["R1f1e", "B8f7g"])
	puzzleMoveLog.append_array(["2c3c", "0-0"])
	puzzleMoveLog.append_array(["2d4d", "5cx4d"])
	puzzleMoveLog.append_array(["3cx4d", "6d5d"])
	puzzleMoveLog.append_array(["4e5e", "N6f4e"])
	puzzleMoveLog.append_array(["N1b2d", "N4ex2d"])
	puzzleMoveLog.append_array(["B1cx2d", "N7d8b"])
	puzzleMoveLog.append_array(["R1a1c", "B8c7d"])
	puzzleMoveLog.append_array(["B4a3b", "B7d5f"])
	puzzleMoveLog.append_array(["R1c5c", "7e6e"])
	puzzleMoveLog.append_array(["B2d5g", "Q8d6b"])
	puzzleMoveLog.append_array(["N3f4h", "N8b7d"])
	puzzleMoveLog.append_array(["N4hx5f", "6gx5f"])
	puzzleMoveLog.append_array(["R5c3c", "7f6f"])
	puzzleMoveLog.append_array(["B5g4f", "6fx5e"])
	puzzleMoveLog.append_array(["4dx5e", "Q6b4b"])
	puzzleMoveLog.append_array(["Q1d1c", "R8a8e"])
	puzzleMoveLog.append_array(["2a3a", "Q4b5a"])
	puzzleMoveLog.append_array(["R3c3g", "R8e8c"])
	puzzleMoveLog.append_array(["Q1c1d", "R8f7f"])
	puzzleMoveLog.append_array(["B4f2d", "Q5a8d"])
	puzzleMoveLog.append_array(["Q1d5h", "N7d8f"])
	puzzleMoveLog.append_array(["B2d5g", "Q8d5a"])
	puzzleMoveLog.append_array(["R1e1d", "N8f6g"])
	puzzleMoveLog.append_array(["R3g3h", "B7g5e"])
	puzzleMoveLog.append_array(["B5g2d", "Q5a6b"])
	puzzleMoveLog.append_array(["Q5h2e", "B5e2b"])
	puzzleMoveLog.append_array(["B2d4b", "B2b7g"])
	puzzleMoveLog.append_array(["Q2e5h", "B7g8f"])
	puzzleMoveLog.append_array(["B4b3c", "R7f7d"])
	puzzleMoveLog.append_array(["B3c4d", "B8f5c"])
	puzzleMoveLog.append_array(["B3b4a", "R7d7c"])
	puzzleMoveLog.append_array(["B4d6f", "R8c8f"])
	puzzleMoveLog.append_array(["Q5h5g", "B5cx2f"])
	puzzleMoveLog.append_array(["K1g1h", "R7c4c"])
	
			
# Remove all pieces from board
func wipe_board():
	var moves = []
	for i in range(1,9,1):
		for j in range(1,9,1):
			var piece = get_tile_piece(get_tile(i, j))
			if piece != null:
				piece.free()
				
func add_starting_pieces():
	# White Rooks
	var tileWR1:Object = get_tile(1,1)
	var WR1: Object = whiterook.instantiate()
	tileWR1.add_child(WR1)
	WR1.set_name("WhiteRook")
	
	var tileWR8:Object = get_tile(1,8)
	var WR8: Object = whiterook.instantiate()
	tileWR8.add_child(WR8)
	WR8.set_name("WhiteRook")
	
	# White Knights
	var tileWN2:Object = get_tile(1,2)
	var WN2: Object = whiteknight.instantiate()
	tileWN2.add_child(WN2)
	WN2.set_name("WhiteKnight")
	
	var tileWN7:Object = get_tile(1,7)
	var WN7: Object = whiteknight.instantiate()
	tileWN7.add_child(WN7)
	WN7.set_name("WhiteKnight")
	
	# White Bishops
	var tileWB3:Object = get_tile(1,3)
	var WB3: Object = whitebishop.instantiate()
	tileWB3.add_child(WB3)
	WB3.set_name("WhiteBishop")
	
	var tileWB6:Object = get_tile(1,6)
	var WB6: Object = whitebishop.instantiate()
	tileWB6.add_child(WB6)
	WB6.set_name("WhiteBishop")
	
	# White Queen
	var tileWQ4:Object = get_tile(1,4)
	var WQ4: Object = whitequeen.instantiate()
	tileWQ4.add_child(WQ4)
	WQ4.set_name("WhiteQueen")
	
	# White King
	var tileWK5:Object = get_tile(1,5)
	var WK5: Object = whiteking.instantiate()
	tileWK5.add_child(WK5)
	WK5.set_name("WhiteKing")
	
	# White Pawns
	for i in range(1,9,1):
		var tile: Object = get_tile(2, i)
		var pawn: Object = whitepawn.instantiate()
		tile.add_child(pawn)
		pawn.set_name("WhitePawn")
	
	# Black Rooks
	var tileBR1:Object = get_tile(8,1)
	var BR1: Object = blackrook.instantiate()
	tileBR1.add_child(BR1)
	BR1.set_name("BlackRook")
	
	var tileBR8:Object = get_tile(8,8)
	var BR8: Object = blackrook.instantiate()
	tileBR8.add_child(BR8)
	BR8.set_name("BlackRook")
	
	# Black Knights
	var tileBN2:Object = get_tile(8,2)
	var BN2: Object = blackknight.instantiate()
	tileBN2.add_child(BN2)
	BN2.set_name("BlackKnight")
	
	var tileBN7:Object = get_tile(8,7)
	var BN7: Object = blackknight.instantiate()
	tileBN7.add_child(BN7)
	BN7.set_name("BlackKnight")
	
	# Black Bishops
	var tileBB3:Object = get_tile(8,3)
	var BB3: Object = blackbishop.instantiate()
	tileBB3.add_child(BB3)
	BB3.set_name("BlackBishop")
	
	var tileBB6:Object = get_tile(8,6)
	var BB6: Object = blackbishop.instantiate()
	tileBB6.add_child(BB6)
	BB6.set_name("BlackBishop")
	
	# Black Queen
	var tileBQ4:Object = get_tile(8,4)
	var BQ4: Object = blackqueen.instantiate()
	tileBQ4.add_child(BQ4)
	BQ4.set_name("BlackQueen")
	
	# Black King
	var tileBK5:Object = get_tile(8,5)
	var BK5: Object = blackking.instantiate()
	tileBK5.add_child(BK5)
	BK5.set_name("BlackKing")
	
	# Black Pawns
	for i in range(1,9,1):
		var tile: Object = get_tile(7, i)
		var pawn: Object = blackpawn.instantiate()
		tile.add_child(pawn)
		pawn.set_name("BlackPawn")
	
func reset_board_to_start():
	can_play = false
	wipe_board()
	await get_tree().create_timer(0.5).timeout
	add_starting_pieces()
	can_play = true
	
func reset_board_to_position(movelog: Array) -> void:
	reset_board_to_start()
	await get_tree().create_timer(0.5).timeout
	can_play = false
	white_to_move = true
	move_log = []
	white_move_log = []
	black_move_log = []
	
	for move in movelog:
		await get_tree().create_timer(0.25).timeout
		resolve_move_no_check(move)
	
	game_over = false
	can_play = true
			
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
		
func all_white_moves_no_expose_king_check() -> Array:
	var moves = []
	for i in range(1,9,1):
		for j in range(1,9,1):
			var piece = get_tile_piece(get_tile(i, j))
			if piece != null && piece.name.to_lower().contains("white"):
				match piece.name:
					"WhitePawn":
						moves.append_array(compute_white_pawn_moves(i, j))
					"WhiteRook":
						moves.append_array(compute_white_rook_moves(i, j))
					"WhiteKnight":
						moves.append_array(compute_white_knight_moves(i, j))
					"WhiteBishop":
						moves.append_array(compute_white_bishop_moves(i, j))
					"WhiteQueen":
						moves.append_array(compute_white_queen_moves(i, j))
					"WhiteKing":
						moves.append_array(compute_white_king_moves(i, j))
					_:
						print(str("INVALID PIECE: ", piece.name))
	return moves
				
	

func all_black_moves_no_expose_king_check() -> Array:
	var moves = []
	for i in range(1,9,1):
		for j in range(1,9,1):
			var piece = get_tile_piece(get_tile(i, j))
			if piece != null && piece.name.to_lower().contains("black"):
				match piece.name:
					"BlackPawn":
						moves.append_array(compute_black_pawn_moves(i, j))
					"BlackRook":
						moves.append_array(compute_black_rook_moves(i, j))
					"BlackKnight":
						moves.append_array(compute_black_knight_moves(i, j))
					"BlackBishop":
						moves.append_array(compute_black_bishop_moves(i, j))
					"BlackQueen":
						moves.append_array(compute_black_queen_moves(i, j))
					"BlackKing":
						moves.append_array(compute_black_king_moves(i, j))
					_:
						print(str("INVALID PIECE: ", piece.name))
	return moves
		
func white_in_check() -> bool:
	# Find the white king
	var i = 1
	var j = 1
	var king = null
	while i <= 8:
		j = 1
		while j <= 8:
			var tile_piece = get_tile_piece(get_tile(i,j))
			if tile_piece != null && tile_piece.name == "WhiteKing":
				king = tile_piece
				break
			j += 1
		if king != null:
			break
		i += 1
	
	# Check if any black pieces have white king as destination in any moves
	var all_black_moves = all_black_moves_no_expose_king_check()
	for move in all_black_moves:
		var dest = get_destination_from_notation(move)
		if (dest[0] == i && dest[1] == j):
			return true
	return false
	
func black_in_check() -> bool:
	# Find the black king
	var i = 1
	var j = 1
	var king = null
	while i <= 8:
		j = 1
		while j <= 8:
			var tile_piece = get_tile_piece(get_tile(i,j))
			if tile_piece != null && tile_piece.name == "BlackKing":
				king = tile_piece
				break
			j += 1
		if king != null:
			break
		i += 1
	
	# Check if any white pieces have black king as destination in any moves
	var all_white_moves = all_white_moves_no_expose_king_check()
	for move in all_white_moves:
		var dest = get_destination_from_notation(move)
		if (dest[0] == i && dest[1] == j):
			return true
	return false
	
func validate_moves(moves: Array) -> Array:
	var valid_moves = []
	for move in moves:
		if validate_move(move):
			valid_moves.append(move)
	return valid_moves
	
			
func _on_player_piece_touched(body: Object) -> void:
	if can_play:
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
					print(str("INVALID PIECE: ", piece.name))
			moves = validate_moves(moves)
			
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
					print(str("INVALID PIECE: ", piece.name))
					
			moves = validate_moves(moves)
					
			print(moves)
			show_move_indicators(moves)
			current_white_moves = moves
			
func _on_player_piece_moved(body: Object) -> void:
	if can_play:
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
					#resolve_move(move)
					resolve_move_bot_response(move)
					return
		
		else:
			for move in current_black_moves:
				var dest = get_destination_from_notation(move)
				
				# TODO:: Pawn promotion?
				
				if dest[0] == row && dest[1] == col:
					resolve_move(move)
					return
				
func validate_move(move: String) -> bool:
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
		var pawn_to_remove_tile = get_tile(row_st, col_dest)
		var pawn_to_remove = get_tile_piece(pawn_to_remove_tile)
		pawn_to_remove.reparent(temp_tile, false)
			
		var selected_piece: Object = get_tile_piece(get_tile(row_st, col_st))
		selected_piece.reparent(tile_dest, false)
		
		var result = false
		if white_to_move:
			result = !white_in_check()
		else:
			result = !black_in_check()
		
		# Put pieces back and return
		pawn_to_remove.reparent(pawn_to_remove_tile, false)
		selected_piece.reparent(tile_st, false)
		return result
		
	# Check if move is kingside castle
	# TODO:: Check all squares king passes through, not just end square
	elif move == "0-0":
		if (white_to_move):
			var rook_tile = get_tile(1,8)
			var rook = get_tile_piece(rook_tile)
			var rook_dest_tile = get_tile(1,6)
			
			var king_tile = get_tile(1,5)
			var king = get_tile_piece(king_tile)
			var king_dest_tile = get_tile(1,7)
			
			king.reparent(king_dest_tile, false)
			rook.reparent(rook_dest_tile, false)
			
			var result = !white_in_check()
			king.reparent(king_tile, false)
			rook.reparent(rook_tile, false)
			return result
		else:
			var rook_tile = get_tile(8,8)
			var rook = get_tile_piece(rook_tile)
			var rook_dest_tile = get_tile(8,6)
			
			var king_tile = get_tile(8,5)
			var king = get_tile_piece(king_tile)
			var king_dest_tile = get_tile(8,7)
			
			king.reparent(king_dest_tile, false)
			rook.reparent(rook_dest_tile, false)
			
			var result = !black_in_check()
			king.reparent(king_tile, false)
			rook.reparent(rook_tile, false)
			return result
		
	# Check if move is queenside castle
	# TODO:: Check all squares king passes through, not just end square
	elif move == "0-0-0":
		if (white_to_move):
			var rook_tile = get_tile(1,1)
			var rook = get_tile_piece(rook_tile)
			var rook_dest_tile = get_tile(1,4)
			
			var king_tile = get_tile(1,5)
			var king = get_tile_piece(king_tile)
			var king_dest_tile = get_tile(1,3)
			
			king.reparent(king_dest_tile, false)
			rook.reparent(rook_dest_tile, false)
			
			var result = !white_in_check()
			king.reparent(king_tile, false)
			rook.reparent(rook_tile, false)
			return result
		else:
			var rook_tile = get_tile(8,1)
			var rook = get_tile_piece(rook_tile)
			var rook_dest_tile = get_tile(8,4)
			
			var king_tile = get_tile(8,5)
			var king = get_tile_piece(king_tile)
			var king_dest_tile = get_tile(8,3)
			
			king.reparent(king_dest_tile, false)
			rook.reparent(rook_dest_tile, false)
			
			var result = !black_in_check()
			king.reparent(king_tile, false)
			rook.reparent(rook_tile, false)
			return result
		
	#Otherwise it's a normal move
	else:
		# Check if piece already at destination, if so move to temp tile
		var piece_at_dest: Object = get_tile_piece(get_tile(row_dest, col_dest))
		if piece_at_dest != null:
			piece_at_dest.reparent(temp_tile, false)
			
		# Move selected piece to destination
		var selected_piece: Object = get_tile_piece(get_tile(row_st, col_st))
		selected_piece.reparent(tile_dest, false)
		
		var result = false
		if white_to_move:
			result = !white_in_check()
		else:
			result = !black_in_check()
		
		# Put pieces back and return
		if piece_at_dest != null:
			piece_at_dest.reparent(get_tile(row_dest, col_dest), false)
		selected_piece.reparent(tile_st, false)
		return result
		
func resolve_move_no_check(move: String) -> void:
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
	
	await get_tree().create_timer(1.0).timeout
	
	# Checking if check mate - white
	if (white_to_move && white_in_check()):
		var all_white_moves = all_white_moves_no_expose_king_check()
		var valid_white_moves = validate_moves(all_white_moves)
		
		if valid_white_moves.size() == 0:
			print("BLACK HAS WON BY CHECKMATE")
			game_over = true
			reset_board_to_position(puzzleMoveLog)
			return
		
	# Checking if check mate - black
	if (!white_to_move && black_in_check()):
		var all_black_moves = all_black_moves_no_expose_king_check()
		var valid_black_moves = validate_moves(all_black_moves)
		
		if valid_black_moves.size() == 0:
			print("WHITE HAS WON BY CHECKMATE")
			game_over = true
			emit_signal("player_won")
			return
		
func resolve_move_bot_response(move: String) -> void:
	resolve_move(move)
	await get_tree().create_timer(1.0).timeout
	
	# TODO:: Bot that actually computes stuff
	if (!white_to_move && !game_over):
		var all_black_moves = all_black_moves_no_expose_king_check()
		var valid_black_moves = validate_moves(all_black_moves)
		
		var rng = RandomNumberGenerator.new()
		rng.randomize()
		var random_move = rng.randi_range(0, valid_black_moves.size()-1)
		resolve_move(valid_black_moves[random_move])


## POSSIBLE MOVES
func compute_white_pawn_moves(row: int, column: int) -> Array:
	var moves = []
	
	# Check if pawn is actually there:
	var pawn = get_tile_piece(get_tile(row, column))
	if pawn == null || !pawn.name.to_lower().contains("whitepawn"):
		return moves
	
	# Moving ahead - check if blocked:
	if (row < 8):
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
	if (column > 1 && row < 8):
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
	if (column < 8 && row < 8):
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
	if (column > 1 && row < 8):
		var piece_left = get_tile_piece(get_tile(row, column-1))
		if piece_left != null && piece_left.name.to_lower().contains("blackpawn"):
			var last_move = move_log[-1]
			var last_move_start = get_start_from_notation(last_move)
			var last_move_dest = get_destination_from_notation(last_move)
			if (row == last_move_dest[0] && column-1 == last_move_dest[1]) && (last_move_start[0] - last_move_dest[0] == 2):
				moves.append(str(row, get_column_letter(column), ":", row+1, get_column_letter(column-1)))
	
	# En Passant - right
	if (column < 8  && row < 8):
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
	if (row > 1):
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
	if (column > 1 && row > 1):
		var piece_left = get_tile_piece(get_tile(row-1, column-1))
		if piece_left != null && piece_left.name.to_lower().contains("white"):
			# Are we capturing into promote?
			if row - 1 == 1:
				moves.append(str(row, get_column_letter(column), "x", row-1, get_column_letter(column-1), "=", "Q")) # Promote to queen
				moves.append(str(row, get_column_letter(column), "x", row-1, get_column_letter(column-1), "=", "N")) # Promote to knight
				moves.append(str(row, get_column_letter(column), "x", row-1, get_column_letter(column-1), "=", "R")) # Promote to rook
				moves.append(str(row, get_column_letter(column), "x", row-1, get_column_letter(column-1), "=", "B")) # Promote to bishop
			else:
				moves.append(str(row, get_column_letter(column), "x", row-1, get_column_letter(column-1)))
				
	# Capturing right
	if (column < 8 && row > 1):
		var piece_right = get_tile_piece(get_tile(row-1, column+1))
		if piece_right != null && piece_right.name.to_lower().contains("white"):
			# Are we capturing into promote?
			if row - 1 == 1:
				moves.append(str(row, get_column_letter(column), "x", row-1, get_column_letter(column+1), "=", "Q")) # Promote to queen
				moves.append(str(row, get_column_letter(column), "x", row-1, get_column_letter(column+1), "=", "N")) # Promote to knight
				moves.append(str(row, get_column_letter(column), "x", row-1, get_column_letter(column+1), "=", "R")) # Promote to rook
				moves.append(str(row, get_column_letter(column), "x", row-1, get_column_letter(column+1), "=", "B")) # Promote to bishop
			else:
				moves.append(str(row, get_column_letter(column), "x", row-1, get_column_letter(column+1)))
		
	# En Passant - left
	if (column > 1 && row > 1):
		var piece_left = get_tile_piece(get_tile(row, column-1))
		if piece_left != null && piece_left.name.to_lower().contains("whitepawn"):
			var last_move = move_log[-1]
			var last_move_start = get_start_from_notation(last_move)
			var last_move_dest = get_destination_from_notation(last_move)
			if (row == last_move_dest[0] && column-1 == last_move_dest[1]) && (last_move_dest[0] - last_move_start[0] == 2):
				moves.append(str(row, get_column_letter(column), ":", row-1, get_column_letter(column-1)))
	
	# En Passant - right
	if (column < 8 && row > 1):
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
		
		while row_iter <= 8 && col_iter >= 1 && piece_ahead == null:
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
			row_iter -= 1
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
			row_iter -= 1
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
