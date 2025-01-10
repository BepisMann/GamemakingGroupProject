extends Button


func _on_pressed() -> void:
	$"..".visible = false
	$"../../Exit_button".visible = true
	$"../../Credits_button".visible =  true
