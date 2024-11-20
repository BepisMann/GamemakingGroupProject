extends Node3D

@export
var noise_img: NoiseTexture2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if noise_img == null:
		print("Error: 'noise_img' is not assigned!")

	# Load the shader
	var shader = load("res://assets/rock/square_wall.gdshader")
	if shader == null:
		print("Error: Shader failed to load!")
		return

	# Create ShaderMaterial and assign the shader
	var shader_material = ShaderMaterial.new()
	shader_material.shader = shader
	
	# Set basic parameters
	shader_material.set_shader_parameter("albedo", Color(1.0, 1.0, 1.0, 1.0))
	shader_material.set_shader_parameter("point_size", 1.0)
	shader_material.set_shader_parameter("roughness", 1.0)
	
	# Set lighting parameters
	shader_material.set_shader_parameter("metallic_texture_channel", Vector4(1.0, 0.0, 0.0, 0.0))
	shader_material.set_shader_parameter("metallic", 0)
	shader_material.set_shader_parameter("emission", Color(0.0, 0.0, 0.0, 1.0))
	shader_material.set_shader_parameter("emission_energy", 0.2)
	shader_material.set_shader_parameter("normal_scale", 2)
	
	shader_material.set_shader_parameter("ao_texture_channel", Vector4(1.0, 0.0, 0.0, 0.0))
	shader_material.set_shader_parameter("ao_light_affect", 0.0)

	# Set UV scaling and offsets
	shader_material.set_shader_parameter("uv1_scale", Vector3(1.0, 1.0, 1.0))
	shader_material.set_shader_parameter("uv1_offset", Vector3(0.0, 0.0, 0.0))
	shader_material.set_shader_parameter("uv2_scale", Vector3(1.0, 1.0, 1.0))
	shader_material.set_shader_parameter("uv2_offset", Vector3(0.0, 0.0, 0.0))

	# Set heightmap parameters
	shader_material.set_shader_parameter("heightmap_scale", 5.0)
	shader_material.set_shader_parameter("heightmap_min_layers", 8)
	shader_material.set_shader_parameter("heightmap_max_layers", 32)
	shader_material.set_shader_parameter("heightmap_flip", Vector2(1.0, 1.0))
	
	# Set texture parameters
	shader_material.set_shader_parameter("texture_albedo", preload("res://assets/rock/rock_08_diff_4k.png"))
	shader_material.set_shader_parameter("texture_roughness", preload("res://assets/rock/rock_08_rough_4k.png"))
	shader_material.set_shader_parameter("texture_emission", preload("res://assets/rock/rock_08_spec_4k.png"))
	shader_material.set_shader_parameter("texture_normal", preload("res://assets/rock/rock_08_disp_4k.png"))
	shader_material.set_shader_parameter("texture_ambient_occlusion", preload("res://assets/rock/rock_08_ao_4k.png"))
	shader_material.set_shader_parameter("texture_heightmap", preload("res://assets/rock/rock_08_disp_4k.png"))
	shader_material.set_shader_parameter("noise_img", noise_img)

	# Assign the material to the MeshInstance3D
	$StaticBody3D/MeshInstance3D.material_override = shader_material

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
