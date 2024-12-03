extends Control
signal respawn

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$RespawnButton.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func play():
	$ShowRespawnButtonTimer.start()
	$AnimationPlayer.play("text_size_increase")
	


func _on_show_respawn_button_timer_timeout() -> void:
	$RespawnButton.show()


func _on_respawn_button_pressed() -> void:
	$RespawnButton.hide()
	emit_signal("respawn")
