extends Button


func _on_pressed() -> void:
	$".".set_text("Loading...")
	await get_tree().create_timer(0.2).timeout
	get_tree().change_scene_to_file("res://scenes/levels/main.tscn")
