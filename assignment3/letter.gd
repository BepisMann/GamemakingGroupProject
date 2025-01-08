extends Control

var is_open: bool = false


func show_letter():
	is_open = true
	visible = true

func _on_mouse_click():
	if is_open:
		is_open = false
		visible = false
		emit_signal("letter_closed") 

func _unhandled_input(event):
	if event is InputEventMouseButton and event.is_pressed():
		print("Mouse got clicked!")
		_on_mouse_click()
