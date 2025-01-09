extends Control

signal letter_closed
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
	if is_open:
		print("Letter event")
		_on_mouse_click()
