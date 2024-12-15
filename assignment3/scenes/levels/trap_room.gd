extends Node3D

signal playerDied

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_trap_body_entered_spikes() -> void:
	emit_signal("playerDied")

func get_trap_tiles() -> Object:
	return $TrapTiles
