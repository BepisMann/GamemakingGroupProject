extends Button


func _on_pressed() -> void:
	$"../Credits_screen".visible = true
	$"../Exit_button".visible = false
	$".".visible = false
