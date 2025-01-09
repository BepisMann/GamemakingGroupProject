extends Node3D

@export
var albedo_texture: Texture2D
@export
var roughness_texture: Texture2D
@export
var emission_texture: Texture2D
@export
var normal_texture: Texture2D
@export
var ambient_occlusion_texture: Texture2D
@export
var heightmap_texture: Texture2D
@export
var noise_img: NoiseTexture2D
@export
var maximum_amplitude: float

# This should be equal to floor length/ floor width (x axis divided by z axis).
@export
var UV_ratio: float 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if albedo_texture == null:
		print("Error: 'albedo_texture' is not assigned for object ", $".".name)
	
	if roughness_texture == null:
		print("Error: 'roughness_texture' is not assigned for object ", $".".name)
	
	#Not there for all materials
	#if emission_texture == null:
		#print("Error: 'emission_texture' is not assigned for object ", $".".name)
	
	if normal_texture == null:
		print("Error: 'normal_texture' is not assigned for object ", $".".name)
	
	if ambient_occlusion_texture == null:
		print("Error: 'ambient_occlusion_texture' is not assigned for object ", $".".name)
	
	if heightmap_texture == null:
		print("Error: 'heightmap_texture' is not assigned for object ", $".".name)
		
	if noise_img == null:
		print("Error: 'noise_img' is not assigned for object ", $".".name)
	
	if maximum_amplitude == null:
		print("Error: 'maximum_amplitude' is not assigned for object ", $".".name)

	# Load the shader
	var shader = load("res://assets/rock/square_floor.gdshader")
	if shader == null:
		print("Error: Shader failed to load!")
		return

	# Create ShaderMaterial and assign the shader
	var shader_material = ShaderMaterial.new()
	shader_material.shader = shader
	
	# Set basic parameters
	shader_material.set_shader_parameter("albedo", Color(0.2, 0.2, 0.2, 1.0))  # Dark gray color
	shader_material.set_shader_parameter("point_size", 1.0)
	shader_material.set_shader_parameter("roughness", 1.0)
	
	# Set lighting parameters
	shader_material.set_shader_parameter("metallic_texture_channel", Vector4(1.0, 0.0, 0.0, 0.0))
	shader_material.set_shader_parameter("metallic", 0)
	shader_material.set_shader_parameter("emission", Color(0.0, 0.0, 0.0, 1.0))
	shader_material.set_shader_parameter("emission_energy", 0.0008)
	shader_material.set_shader_parameter("normal_scale", 2)
	
	shader_material.set_shader_parameter("ao_texture_channel", Vector4(1.0, 0.0, 0.0, 0.0))
	shader_material.set_shader_parameter("ao_light_affect", 0.0)

	# Set UV scaling and offsets
	shader_material.set_shader_parameter("uv1_scale", Vector3(UV_ratio, 1.0, 1.0))
	shader_material.set_shader_parameter("uv1_offset", Vector3(0.0, 0.0, 0.0))
	shader_material.set_shader_parameter("uv2_scale", Vector3(UV_ratio, 1.0, 1.0))
	shader_material.set_shader_parameter("uv2_offset", Vector3(0.0, 0.0, 0.0))

	# Set heightmap parameters
	shader_material.set_shader_parameter("heightmap_scale", 1.0)
	shader_material.set_shader_parameter("heightmap_min_layers", 8)
	shader_material.set_shader_parameter("heightmap_max_layers", 32)
	shader_material.set_shader_parameter("heightmap_flip", Vector2(1.0, 1.0))
	
	# Set texture parameters
	shader_material.set_shader_parameter("texture_albedo", albedo_texture)
	shader_material.set_shader_parameter("texture_roughness", roughness_texture)
	shader_material.set_shader_parameter("texture_emission", emission_texture)
	shader_material.set_shader_parameter("texture_normal", normal_texture)
	shader_material.set_shader_parameter("texture_ambient_occlusion", ambient_occlusion_texture)
	shader_material.set_shader_parameter("texture_heightmap", heightmap_texture)
	shader_material.set_shader_parameter("noise_img", noise_img)
	shader_material.set_shader_parameter("max_amplitude", maximum_amplitude)

	# Assign the material to the MeshInstance3D
	$".".material_override = shader_material

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
