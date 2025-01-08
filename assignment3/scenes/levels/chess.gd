extends Node3D

signal piece_moved
signal piece_touched

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_room_3_piece_moved(body: Object) -> void:
	emit_signal("piece_moved", body)


func _on_room_3_piece_touched(body: Object) -> void:
	emit_signal("piece_touched", body)
