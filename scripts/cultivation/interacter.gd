extends Node3D

var distance = 100.0

signal update_prompt_text
signal harvested_crop

@export var corn_scene : PackedScene
@export var plantation_scene : PackedScene

func _process(_delta):
	if Input.is_action_just_pressed("interacao"):
		interact()
	if Input.is_action_just_pressed("plant"):
		plant()
	if Input.is_action_just_pressed("prepare_ground"):
		prepare_ground()
	
	var result = raycast(2)
	if result:
		emit_signal("update_prompt_text", result.collider.update_prompt_text())
	else:
		emit_signal("update_prompt_text", "")
		
		
func interact():
	var result = raycast(2)
	if result:
		if result.collider.has_method("interact"):
			if result.collider.harvestable:
				emit_signal("harvested_crop", result.collider.get_crop_type(),result.collider.get_harvest_amount())
				result.collider.interact()

func plant():
	var result = raycast(3)
	if result.collider.get_collision_layer() == 5 && !result.collider.occupied:
		print("Raio colidiu com: ", result.collider.get_collision_layer())
		result.collider.occupied = true
		var corn_instance = corn_scene.instantiate()
		get_tree().get_root().add_child(corn_instance)
		corn_instance.global_transform.origin = result.position
		corn_instance.rotate_y(randf_range(0.0, TAU))
		corn_instance.global_scale(Vector3.ONE * randf_range(0.9,1.1))

func prepare_ground():
	var result = raycast(1)
	if result.collider.get_collision_layer() == 1:
		print("Raio colidiu com: ", result.collider.get_collision_layer())
		var plantation_instance = plantation_scene.instantiate()
		get_tree().get_root().add_child(plantation_instance)
		plantation_instance.global_transform.origin = result.position
		
func raycast(layer: int):
	var space_state = get_world_3d().get_direct_space_state()
	var cam = get_node("../CameraPivot/FirstPerson")  # Caminho para a câmera
	var mouse_pos = get_viewport().get_mouse_position()

	# Calcula a origem e a direção do raio com base na posição do mouse
	var origin = cam.project_ray_origin(mouse_pos)
	var end = origin + cam.project_ray_normal(mouse_pos) * distance

	# Configurando os parâmetros do raycast
	var query = PhysicsRayQueryParameters3D.new()
	query.from = origin
	query.to = end
	query.collision_mask = layer  # Camada de colisão
	query.collide_with_areas = true  # Permitir colisão com áreas

	# Executando o raycast
	var result = space_state.intersect_ray(query)
	return result

	
