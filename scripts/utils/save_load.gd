extends Node

var game : Game
var pending_save_name: String = ""

func initialize(game_node : Node):
	game = game_node

# Salva os dados do jogo usando o nome informado pelo jogador
func save_game(save_name: String) -> void:
	var save_data = {}

	# 1. Salva o inventário
	save_data["inventory"] = InventoryManager.save()

	# 2. Salva os dados da loja
	save_data["shop"] = {
		"player_money": ShopManager.player_money
	}

	# 3. Salva o estado do jogador
	save_data["player"] = {
		"position": {
			"x": game.player.position.x,
			"y": game.player.position.y,
			"z": game.player.position.z
		}
	}

	# 4. Salva a posição de todas as galinhas
	var chicken_positions = []
	for chicken in get_tree().get_nodes_in_group("chickens"):
		print("saving chicken")
		chicken_positions.append({
			"x": chicken.global_position.x,
			"y": chicken.global_position.y,
			"z": chicken.global_position.z
		})
	save_data["chickens"] = chicken_positions

	# Outros sistemas podem ser adicionados aqui.

	# O arquivo será salvo com o nome dado: por exemplo, "MeuSave.save"
	var file_path = "user://%s.save" % save_name
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	file.store_var(save_data)
	file.close()
	print("Jogo salvo com o nome: %s" % save_name)

# Carrega os dados do jogo a partir do nome do save
func load_game(save_name: String) -> void:
	var file_path = "user://%s.save" % save_name
	if not FileAccess.file_exists(file_path):
		print("Save com o nome '%s' não encontrado!" % save_name)
		return

	var file = FileAccess.open(file_path, FileAccess.READ)
	var save_data = file.get_var()
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
		game.player.position = Vector3(pos_dict["x"], pos_dict["y"], pos_dict["z"])

	# 4. Carrega as galinhas
	if save_data.has("chickens"):
		var chicken_scene = preload("res://scenes/animals/chicken.tscn")
		for pos_dict in save_data["chickens"]:
			var chicken = chicken_scene.instantiate()
			chicken.global_position = Vector3(pos_dict["x"], pos_dict["y"], pos_dict["z"])
			get_tree().current_scene.add_child(chicken)

	print("Jogo carregado com o nome: %s" % save_name)

# Verifica se existe um save com o nome especificado
func has_save(save_name: String) -> bool:
	var file_path = "user://%s.save" % save_name
	return FileAccess.file_exists(file_path)

func set_pending_save(save_name: String) -> void:
	pending_save_name = save_name
