extends Node3D


func _ready() -> void:
	var animation_player = $AnimationPlayer
	if animation_player and animation_player.has_animation("Up_and_down"):
		animation_player.play("Up_and_down")
	
	
	
