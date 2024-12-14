extends StaticBody3D

@export var medallion_type: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	collision_layer = 2
	collision_mask = 2
