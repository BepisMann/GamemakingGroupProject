extends Node3D

@onready var medallion_holders := get_children()

func update_puzzle_state():
	for holder in medallion_holders:
		if holder.has_method("check_correct_medallion") and not holder.check_correct_medallion():
			return
	 
	#For whoever is coding this, all is setup already, just code the wall destruction/removal/movement here
	print("All medallions are correctly placed! Open wall code here!")
