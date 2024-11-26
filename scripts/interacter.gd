extends Node3D

var distance = 5.0

signal update_prompt_text
signal harvested_crop

@export var corn_scene : PackedScene

func _process(_delta):
	if Input.is_action_just_pressed("interacao"):
		interact()
	if Input.is_action_just_pressed("plant"):
		plant()
	
	var result = raycast(2)
	if result:
		if result.collider.has_method("interact"):
				emit_signal("update_prompt_text", result.collider.update_prompt_text())
		else:
			emit_signal("update_prompt_text", "")
	else:
		emit_signal("update_prompt_text", "")
		
func interact():
	var result = raycast(2)
	if result:
		if result.collider.has_method("interact"):
			emit_signal("harvested_crop", result.collider.get_harvest_amount())
			result.collider.interact()

func plant():
	var result = raycast(1)
	if result:
		var corn_instance = corn_scene.instantiate()
		get_tree().get_root().add_child(corn_instance)
		corn_instance.global_transform.origin = result.position
		corn_instance.rotate_y(randf_range(0.0, TAU))
		corn_instance.global_scale(Vector3.ONE * randf_range(0.9,1.1))

func raycast(layer:int):
	var space_state = get_world_3d().get_direct_space_state()
	var our_position = global_transform.origin
	# Criando os parâmetros do raio
	var ray_params = PhysicsRayQueryParameters3D.new()
	ray_params.from = our_position
	ray_params.to = our_position - global_transform.basis.z * distance
	ray_params.collision_mask = layer  # Define a camada de colisão
	ray_params.exclude = []  # Lista de nós a serem ignorados
	ray_params.hit_from_inside = true  # Colisões internas
	ray_params.collide_with_areas = true  # Permitir colisão com áreas

	# Chamando o intersect_ray
	var result = space_state.intersect_ray(ray_params)
	
	return result
	
