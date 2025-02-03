extends GridContainer

@export var slot_scene: PackedScene

func _ready():
	setup_slots()
	InventoryManager.inventory_updated.connect(update_hotbar)

func setup_slots():
	for i in range(InventoryManager.HOTBAR_SIZE):
		var slot = slot_scene.instantiate()
		add_child(slot)
		slot.set_item(InventoryManager.get_hotbar_item(i))

# Atualiza a hotbar refletindo as mudanças no inventário
func update_hotbar():
	for i in range(InventoryManager.HOTBAR_SIZE):
		var slot = get_child(i)
		slot.set_item(InventoryManager.get_hotbar_item(i))
