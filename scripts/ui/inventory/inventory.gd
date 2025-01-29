extends Control

@export var slot_scene: PackedScene
@onready var hotbar = $Margin/Panel/Margin/VBox/Hotbar
@onready var inventory_grid = $Margin/Panel/Margin/VBox/InventoryGrid


func _ready():
	initialize_ui()
	InventoryManager.inventory_updated.connect(refresh_inventory_ui)
	InventoryManager.hotbar_updated.connect(refresh_hotbar_ui)


func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_K:
			var item: Item = load("res://resources/items/espada.tres")
			InventoryManager.add_item_to_inventory(item)
		elif event.pressed and event.keycode == KEY_L:
			InventoryManager.remove_item_from_inventory("Espada", 1)


# Inicializa a interface com os slots
func initialize_ui():
	clear_children(hotbar)
	clear_children(inventory_grid)

	# Cria os slots da hotbar
	for i in range(InventoryManager.HOTBAR_SIZE):
		var slot = slot_scene.instantiate()
		hotbar.add_child(slot)

	# Cria os slots do inventário
	for i in range(InventoryManager.INVENTORY_SIZE):
		var slot = slot_scene.instantiate()
		inventory_grid.add_child(slot)

	# Atualiza os dados dos slots após a inicialização
	refresh_inventory_ui()
	refresh_hotbar_ui()


# Atualiza todos os slots na UI
func refresh_inventory_ui():
	for i in range(InventoryManager.INVENTORY_SIZE):
		var slot = inventory_grid.get_child(i)
		slot.set_item(InventoryManager.get_inventory_item(i))

func refresh_hotbar_ui():
	for i in range(InventoryManager.HOTBAR_SIZE):
		var slot = hotbar.get_child(i)
		slot.set_item(InventoryManager.get_hotbar_item(i))

# Atualiza um único slot no inventário
func refresh_inventory_slot(slot_index: int):
	if slot_index >= 0 and slot_index < InventoryManager.INVENTORY_SIZE:
		var slot = inventory_grid.get_child(slot_index)
		slot.set_item(InventoryManager.get_inventory_item(slot_index))


# Atualiza um único slot da hotbar
func refresh_hotbar_slot(slot_index: int):
	if slot_index >= 0 and slot_index < InventoryManager.HOTBAR_SIZE:
		var slot = hotbar.get_child(slot_index)
		slot.set_item(InventoryManager.get_hotbar_item(slot_index))


# Remove todos os filhos de um nó
func clear_children(node: Node):
	for child in node.get_children():
		child.queue_free()
