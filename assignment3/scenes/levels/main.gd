extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Death.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_player_player_died() -> void:
	$DeathTimer.start()
	
func _on_death_respawn() -> void:
	for line in $"TrapRoom (Room 3)".get_trap_tiles().get_children():
		for trap in line.get_children():
			trap.rearm()
	
	$"Player".position = $PlayerRespawnPoint.position
	$Death.hide()
	$UI.show()
	$"Player".can_control = true
	$"Player".can_jump = true
	$"Player".show_cursor()
	$"Player".respawn()

func _on_death_timer_timeout() -> void:
	$UI.hide()
	$Death.show()
	$Death.play()