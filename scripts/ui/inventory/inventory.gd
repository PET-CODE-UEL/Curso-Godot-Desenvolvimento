extends Control

@export var slot_scene: PackedScene
@onready var hotbar_grid: GridContainer = $Margin/Panel/Margin/VBox/HotbarGrid
@onready var inventory_grid: GridContainer = $Margin/Panel/Margin/VBox/InventoryGrid

func _ready():
	initialize_ui()
	InventoryManager.inventory_updated.connect(refresh_ui)

# Inicializa a interface com os slots
func initialize_ui():
	clear_children(hotbar_grid)
	clear_children(inventory_grid)

	# Cria os slots do inventário
	for i in range(InventoryManager.INVENTORY_SIZE):
		var slot = slot_scene.instantiate()
		slot.slot_index = i
		slot.add_to_group("inventory_slots")
		inventory_grid.add_child(slot)

	# Cria os slots da hotbar_grid
	for i in range(InventoryManager.HOTBAR_SIZE):
		var slot = slot_scene.instantiate()
		slot.slot_index = i + InventoryManager.INVENTORY_SIZE
		slot.add_to_group("inventory_slots")
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
