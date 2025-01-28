extends GridContainer

@export var slot_scene: PackedScene

func _ready():
    setup_slots()

func setup_slots():
    for i in range(9):
        var slot = slot_scene.instantiate()
        add_child(slot)
        slot.set_item(InventoryManager.get_hotbar_item(i))

func update_hotbar():
    for i in range(9):
        var slot = get_child(i)
        InventoryManager.set_hotbar_item(i, slot.item)
