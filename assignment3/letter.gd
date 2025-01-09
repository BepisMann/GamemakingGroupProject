extends Control

var is_open: bool = true

func _process(delta: float) -> void:
	if is_open == false:
		queue_free()

func set_letter_bool(new_value: bool):
	is_open = new_value
	print("Letter boolean updated to: ", is_open)
