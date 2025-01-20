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
	var result = raycast(2) # Camada de colisao 2 -> 010 b = 2 d
	if result:
		if result.collider.get_collision_layer() == 2:
			var crop = result.collider
			if crop.harvestable:
				emit_signal("harvested_crop", crop.get_crop_type(),crop.get_harvest_amount())
				crop.interact()
				crop.plantation.occupied = false
				

func plant():
	var result = raycast(4) # Camada de colisao 3 -> 100 b = 4 d
	if result:
		if result.collider.get_collision_layer() == 4  : # Checa se eh um terreno pra plantar
			var plantation = result.collider
			if !plantation.occupied : # Checa se o terreno ja esta ocupado
				var corn_instance = corn_scene.instantiate()
				corn_instance.plantation = plantation
				get_tree().get_root().add_child(corn_instance)
				 # Calcula o centro do quadrado
				var center_position = plantation.global_transform.origin
				corn_instance.global_transform.origin = center_position
				
				corn_instance.rotate_y(randf_range(0.0, TAU))
				corn_instance.global_scale(Vector3.ONE * randf_range(0.9,1.1))
				plantation.occupied = true # Ocupa terreno

func prepare_ground():
	var result = raycast(1)
	if result:
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

	
