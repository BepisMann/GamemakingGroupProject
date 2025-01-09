extends Node3D
@onready var boulder_instance: Node = $"BoulderRoom (Room4)"
@onready var letter_ui = $"UI/Letter"

var boulder_scene: PackedScene = preload("res://scenes/levels/boulder.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Player.connect("change_letter_bool", Callable(self,"_on_change_letter_bool"))
	$Death.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_player_player_died() -> void:
	_on_trap_room_room_3_player_died()
	$DeathTimer.start()
	
func _on_death_respawn() -> void:
	for line in $"TrapRoom (Room 3)".get_trap_tiles().get_children():
		for trap in line.get_children():
			trap.rearm()
	
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
	if boulder_instance:
		boulder_instance.queue_free()
		
	boulder_instance = boulder_scene.instantiate()
	add_child(boulder_instance)
	
	boulder_instance.position = $BoulderPlaceholder.position
	boulder_instance.rotation = $BoulderPlaceholder.rotation
	boulder_instance.name = "BoulderRoom (Room4)"

func _on_change_letter_bool(new_value: bool):
	if letter_ui:
		letter_ui.set_letter_bool(new_value)
	else:
		print("Letter scene not found!")
