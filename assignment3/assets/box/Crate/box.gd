extends RigidBody3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func break_crate() -> void:
	$"AudioStreamPlayer3D".play()


func _on_audio_stream_player_3d_finished() -> void:
	self.hide()
	
	await get_tree().create_timer(4.0).timeout
	
	self.show()
