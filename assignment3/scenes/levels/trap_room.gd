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
	for line in $TrapTiles.get_children():
		for trap in line.get_children():
			trap.rearm()
	
	$Player.position = $PlayerRespawnPoint.position
	$Death.hide()

func _on_death_timer_timeout() -> void:
	$Death.show()
	$Death.play()
