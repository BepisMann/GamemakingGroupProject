extends Node3D

@onready var letter_ui = $"UI/Letter"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	letter_ui.show_letter()

	$Player.can_control = false

	letter_ui.connect("letter_closed", Callable(self, "_on_letter_closed"))
	$Death.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_player_player_died() -> void:
	$DeathTimer.start()
	
func _on_death_respawn() -> void:
	# Reset room 3
	for line in $"TrapRoom (Room 3)".get_trap_tiles().get_children():
		for trap in line.get_children():
			trap.rearm()
	
	# Reset boulder room
	$"BoulderRoom (Room4)".reset()
	
	var respawn_point = $"Player".get_respawn_point()
	if respawn_point == 1:
		$"Player".position = $PlayerRespawnPoint1.position
	elif respawn_point == 2:
		$"Player".position = $PlayerRespawnPoint2.position
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


func _on_trap_room_room_3_player_died() -> void:
	pass # Replace with function body.
