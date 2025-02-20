extends Node3D

var hud_scene = preload("res://scenes/ui/hud.tscn")  # Carrega a cena
@onready var hud: Node = null
@onready var hotbar: Node = null

func _ready():
	var hud_instance = hud_scene.instantiate()  # Instancia a HUD
	get_tree().get_root().add_child(hud_instance)  # Adiciona na árvore de nós
	
	await get_tree().process_frame  # 🔥 Espera um frame para garantir que a HUD foi carregada
	hud = get_node_or_null("/root/Main/UI/HUD")  # 🔥 Pegando o HUD corretamente

	if hud:
		hotbar = hud.get_node_or_null("Margin/Margin/Hotbar")  # 🔥 Pegando o Hotbar dentro da HUD
		if hotbar:
			hotbar.connect("slot_selected", update_hand_item)  # 🔥 Conectando ao evento de seleção
			print("✅ Hotbar conectado com sucesso!")
		else:
			print("❌ ERRO: Hotbar não encontrado dentro da HUD.")
	else:
		print("❌ ERRO: HUD não encontrado na árvore de nós.")


func update_hand_item(slot_index: int): 
	for child in get_children():
		if not (child is AnimationPlayer or child is AnimationTree):
				child.queue_free()
	print("🔎 Slot selecionado:", slot_index)
	# 🔥 Verifica se o InventoryManager está funcionando corretamente
	var item = InventoryManager.get_hotbar_item(slot_index)
	print("📦 Item recebido do InventoryManager:", item)

	if item == null:
		print("❌ Nenhum item encontrado no slot!")
		return  # Evita tentar carregar um item nulo

	# 🔥 Se chegou aqui, significa que um item foi retornado, mas pode não ter uma cena
	if item.scene_path == "":
		print("⚠ Erro: O item não tem um caminho de cena válido!")
		print(item.scene_path)
		return

	# 🔥 Tenta carregar a cena do item
	var item_scene = load(item.scene_path)
	if item_scene:
		var item_instance = item_scene.instantiate()
		add_child(item_instance)
		
		print("✅ Item instanciado na mão: " + item.scene_path)
	else:
		print("⚠ Erro: Não foi possível carregar a cena do item!")
