extends Node3D

var distance = 100.0

signal update_prompt_text
signal harvested_crop

@export var corn_scene : PackedScene
@export var plantation_scene : PackedScene

# PROCESS QUE CHECA A POSSIBILIDADE DE ACOES
func _process(_delta):
	if Input.is_action_just_pressed("interacao"):
		interact()
	if Input.is_action_just_pressed("plant"):
		plant()
	if Input.is_action_just_pressed("prepare_ground"):
		prepare_ground()
	if Input.is_action_just_pressed("watering_crop"):
		watering_crop()
	if Input.is_action_just_pressed("fertilizing"):
		fertilizing_soil()
		
	var crop_ray = raycast(2)
	var soil_ray = raycast(4)
	var ground_ray = raycast(1)
	if crop_ray:
		emit_signal("update_prompt_text", crop_ray.collider.update_prompt_text())
	elif soil_ray:
		emit_signal("update_prompt_text", soil_ray.collider.update_prompt_text())
	elif ground_ray:
		emit_signal("update_prompt_text", ground_ray.collider.update_prompt_text())
	else:
		emit_signal("update_prompt_text", "")

# ==============================================================================
# SEGUEM AS FUNCOES BASICAS DO JOGO
# NOTA SE QUE ELAS SE ASSEMELHAM MUITO
# 1 - JOGAR O RAYCAST NA CAMADA DO OBJETO QUE SERA USADO
# 2 - CHECAR SE O RAIO ENCONTROU O OBJETO EM QUESTAO
# 3 - FAZER AS MUDANCAS NECESSARIAS

# FUNCAO DE COLHER
func interact():
	var result = raycast(2) # Camada de colisao 2 -> 010 b = 2 d
	if result:
		if result.collider.get_collision_layer() == 2:
			var crop = result.collider
			if crop.harvestable:
				emit_signal("harvested_crop", crop.get_crop_type(),crop.get_harvest_amount())
				crop.interact()
				
				crop.plantation.occupied = false # Desocupa o solo
				crop.plantation.fertilized = false # Remove fertilizande do solo
				crop.plantation.crop = null # Remove referencia da crop em plantation

# FUNCAO DE PLANTAR
func plant():
	var result = raycast(4) # Camada de colisao 3 -> 100 b = 4 d
	if result:
		if result.collider.get_collision_layer() == 4  : # Checa se eh um terreno pra plantar
			var soil = result.collider
			if !soil.occupied : # Checa se o terreno ja esta ocupado
				var corn_instance = corn_scene.instantiate()
				corn_instance.plantation = soil
				get_tree().get_root().add_child(corn_instance)
				 # Calcula o centro do quadrado
				var center_position = soil.global_transform.origin
				corn_instance.global_transform.origin = center_position
				
				corn_instance.rotate_y(randf_range(0.0, TAU))
				corn_instance.global_scale(Vector3.ONE * randf_range(0.9,1.1))
				soil.occupied = true # Ocupa terreno
				soil.crop = corn_instance # Referencia a planta ao terreno
				if soil.fertilized:
					corn_instance.growth_time *= 0.9 # Diminui o tempo de crescimento em 10% 

# FUNCAO DE CRIAR O SOLO DE PLANTIO
func prepare_ground():
	var result = raycast(1)
	if result:
		if result.collider.get_collision_layer() == 1:
			print("Raio colidiu com: ", result.collider.get_collision_layer())
			var plantation_instance = plantation_scene.instantiate()
			get_tree().get_root().add_child(plantation_instance)
			plantation_instance.global_transform.origin = result.position

# FUNCAO DE REGAR A PLANTA 
func watering_crop():
	var result = raycast(2)
	if result:
		if result.collider.get_collision_layer() == 2:
				var crop = result.collider
				if !crop.watered:
					print("Regado")
					crop.growth_value += 0.1 # Acelera 10% o crescimento
					crop.watered = true

# FUNCAO DE FERTILIZAR O SOLO
func fertilizing_soil():
	var result = raycast(4)
	if result:
		if result.collider.get_collision_layer() == 4:
			var soil = result.collider
			if !soil.fertilized: # Se o solo tiver uma planta e nao estiver fertilizado
				print("Fertilizado")
				soil.fertilized = true

# FUNCAO BASICA DE RAYCAST
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

	
