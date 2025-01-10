extends Area3D


func _on_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		body.backgroundMusic1.stop()
		$Finishing_game_sound.play()
		$Game_finish_particles.emitting = true
		$"../../../UI/Finish_screen".visible = true
		body.can_control = false
		body.velocity = Vector3.ZERO
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
