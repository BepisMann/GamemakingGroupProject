extends Node3D

@onready var medallion_holders := get_children()

@onready var door_opening_sound = $Door_opening_sound
@onready var drums = $Drums_of_opening_door
@onready var delay_timer = $Door_opening_sound/DelayTimer

func update_puzzle_state():
	for holder in medallion_holders:
		if holder.has_method("check_correct_medallion") and not holder.check_correct_medallion():
			return
	 
	#For whoever is coding this, all is setup already, just code the wall destruction/removal/movement here
	print("All medallions are correctly placed! Open wall code here!")
	drums.play()
	delay_timer.start()
	

func _on_delay_timer_timeout() -> void:
	door_opening_sound.play()
