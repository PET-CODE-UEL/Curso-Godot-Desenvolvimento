extends Control

@onready var item_list: ItemList = $Margin/Margin/VBox/ItemList

# Vetor que armazenará os nomes dos arquivos de save encontrados (com extensão)
var save_files: Array = []

func _ready() -> void:
	update_save_list()

func update_save_list() -> void:
	save_files.clear()
	item_list.clear()

	var dir = DirAccess.open("user://")
	if dir:
		dir.list_dir_begin()
		while true:
			var file_name = dir.get_next()
			if file_name == "":
				break
			# Procura por arquivos que terminem com ".save"
			if not dir.current_is_dir() and file_name.ends_with(".save"):
				save_files.append(file_name)
				# Remove a extensão ".save" para exibir somente o nome dado pelo usuário
				var display_name = file_name.substr(0, file_name.length() - 5)
				item_list.add_item(display_name)
		dir.list_dir_end()

	if save_files.is_empty():
		item_list.add_item("Nenhum save encontrado")

func _on_load_pressed() -> void:
	var selected = item_list.get_selected_items()
	if selected.is_empty():
		print("Nenhum save selecionado!")
		return

	var index = selected[0]
	if save_files.is_empty():
		return

	var file_name = save_files[index]
	# Extraia o nome do save removendo a extensão ".save"
	var save_name = file_name.substr(0, file_name.length() - 5)

	# Armazena o nome do save para ser carregado no novo cenário
	SaveLoad.set_pending_save(save_name)

	# Troque para a cena principal do jogo (ajuste o caminho conforme necessário)
	get_tree().change_scene_to_file("res://scenes/main_scene.tscn")
	print("Preparando o load do save: %s" % save_name)


func _on_back_pressed() -> void:
	# Retorne ao menu anterior (ajuste o caminho se necessário)
	var main_menu = get_parent().get_parent()
	main_menu.set_button_menu(true)
