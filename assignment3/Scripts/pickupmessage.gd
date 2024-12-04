extends Label

@onready var timer: Timer = $PickupTimer 


func show_pickup_message(message: String):
	self.text = message
	self.visible = true
	timer.start()  

func _on_pickup_timer_timeout() -> void:
	self.text = ""
	self.visible = false
