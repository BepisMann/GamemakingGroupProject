extends Node3D
signal bodyEnteredCeilingSpikes

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func activate():
	$AnimationPlayer.play("Spike_animation")


func _on_spike_area_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		emit_signal("bodyEnteredCeilingSpikes")
