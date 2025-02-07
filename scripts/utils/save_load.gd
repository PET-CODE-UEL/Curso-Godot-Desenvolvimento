extends Node

# Salva os dados do jogo em um determinado slot
func save_game(slot: int) -> void:
	var save_data = {}

	# 1. Salva o inventário
	save_data["inventory"] = InventoryManager.save()
	
	# 2. Salva dados da loja
	save_data["shop"] = {
		"player_money": ShopManager.player_money
	}
	
	# 3. Salva o estado do jogador
	save_data["player"] = {
		"position": {
			"x": Player.position.x,
			"y": Player.position.y,
			"z": Player.position.z
		}    
	}

	# 4. Salva a posicao de todas as galinhas
	var chicken_positions = []
	for chicken in get_tree().get_nodes_in_group("chickens"):
		print("saving chicken")
		chicken_positions.append({
			"x": chicken.global_position.x,
			"y": chicken.global_position.y,
			"z": chicken.global_position.z
		})
	save_data["chickens"] = chicken_positions
	
	# Se tiver outros sistemas (por exemplo, estado do mundo, plantações, etc.),
	# adicione-os aqui.
	
	# Abre (ou cria) o arquivo de save no diretório do usuário e grava os dados
	var file_path = "user://save_slot_%d.save" % slot
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	file.store_var(save_data)
	file.close()
	print("Jogo salvo no slot %d!" % slot)

# Carrega os dados do jogo a partir de um determinado slot
func load_game(slot: int) -> void:
	var save_data = {}
	var file_path = "user://save_slot_%d.save" % slot
	if not FileAccess.file_exists(file_path):
		print("Nenhum save encontrado no slot %d!" % slot)
		return

	var file = FileAccess.open(file_path, FileAccess.READ)
	save_data = file.get_var()
	file.close()
	
	# 1. Carrega o inventário
	if save_data.has("inventory"):
		InventoryManager.load(save_data["inventory"])
	
	# 2. Carrega os dados da loja
	if save_data.has("shop"):
		ShopManager.set_money(save_data["shop"]["player_money"])
	
	# 3. Carrega os dados do jogador
	if save_data.has("player"):
		var pos_dict = save_data["player"]["position"]
		# Converte o dicionário para um Vector3 e atribui à posição do jogador
		Player.position = Vector3(pos_dict["x"], pos_dict["y"], pos_dict["z"])

	# 4. Carrega as galinhas
	if save_data.has("chickens"):
		var chicken_scene = preload("res://scenes/animals/chicken.tscn")
		for pos_dict in save_data["chickens"]:
			var chicken = chicken_scene.instantiate()
			chicken.global_position = Vector3(pos_dict["x"], pos_dict["y"], pos_dict["z"])
			get_tree().current_scene.add_child(chicken)
	
	print("Jogo carregado do slot %d!" % slot)

# Verifica se existe um save no slot especificado
func has_save(slot: int) -> bool:
	var file_path = "user://save_slot_%d.save" % slot
	return FileAccess.file_exists(file_path)
