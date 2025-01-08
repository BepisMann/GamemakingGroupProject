extends Area3D


func _on_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		$Finishing_game_sound.play()
		$Game_finish_particles.emitting = true
		# Add code here that makes finish_screen in main visible 
		# Add code that stops player from moving when this happens
		# Cancel main music  before playing Finishing_game_sound
