extends Control

@export var slot_scene: PackedScene
@onready var hotbar_grid = $Margin/Panel/Margin/VBox/HotbarGrid
@onready var inventory_grid = $Margin/Panel/Margin/VBox/InventoryGrid

func _ready():
	initialize_ui()
	InventoryManager.inventory_updated.connect(refresh_ui)

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_K:
			var item: Item = load("res://resources/items/espada.tres")
			InventoryManager.add_item_to_inventory(item)
		elif event.pressed and event.keycode == KEY_L:
			InventoryManager.remove_item_from_inventory("Espada", 1)

# Inicializa a interface com os slots
func initialize_ui():
	clear_children(hotbar_grid)
	clear_children(inventory_grid)

	# Cria os slots do inventário
	for i in range(InventoryManager.INVENTORY_SIZE):
		var slot = slot_scene.instantiate()
		inventory_grid.add_child(slot)

	# Cria os slots da hotbar_grid
	for i in range(InventoryManager.HOTBAR_SIZE):
		var slot = slot_scene.instantiate()
		hotbar_grid.add_child(slot)

	# Atualiza os dados dos slots após a inicialização
	refresh_ui()

# Atualiza todos os slots na UI
func refresh_ui():
	for i in range(InventoryManager.INVENTORY_SIZE):
		var slot = inventory_grid.get_child(i)
		var item = InventoryManager.get_inventory_item(i)
		slot.set_item(item)

	for i in range(InventoryManager.HOTBAR_SIZE):
		var slot = hotbar_grid.get_child(i)
		var item = InventoryManager.get_hotbar_item(i)
		slot.set_item(item)

# Remove todos os filhos de um nó
func clear_children(node: Node):
	for child in node.get_children():
		child.queue_free()
