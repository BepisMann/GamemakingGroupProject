extends Node3D

@onready var medallion_holders := get_medallion_holders()

@onready var door_opening_sound = $Door_opening_sound
@onready var drums = $Drums_of_opening_door
@onready var delay_timer = $Door_opening_sound/DelayTimer

@onready var closed_door_wall = $"../../room 1/ClosedDoorWall"

func get_medallion_holders() -> Array[Object]:
	var holders: Array[Object] = []
	holders.append($Wall4/Medaillon_holder)
	holders.append($Wall5/Medaillon_holder2)
	holders.append($Wall6/Medaillon_holder4)
	holders.append($Wall7/Medaillon_holder3)
	return holders
	

func update_puzzle_state():
	for holder in medallion_holders:
		if holder.has_method("check_correct_medallion") and not holder.check_correct_medallion():
			return
	 
	#For whoever is coding this, all is setup already, just code the wall destruction/removal/movement here
	print("All medallions are correctly placed! Open wall code here!")
	for child in medallion_holders:
		child.lock()
	drums.play()
	delay_timer.start()
	
	var parent = closed_door_wall.get_parent()
	var wall_transform = closed_door_wall.transform
	var open_wall = preload("res://scenes/prefabs/Door_Room1_to_Room3/OpenDoorWall.tscn")
	var open_wall_instance = open_wall.instantiate()
	closed_door_wall.queue_free()
	
	parent.add_child(open_wall_instance)
	open_wall_instance.transform = wall_transform
	
	

func _on_delay_timer_timeout() -> void:
	door_opening_sound.play()
