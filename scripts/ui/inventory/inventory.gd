extends Control

@onready var hotbar = $Margin/Panel/Margin/VBox/Hotbar
@onready var inventory_grid = $Margin/Panel/Margin/VBox/InventoryGrid

func _ready():
    setup_hotbar()
    setup_inventory()

func setup_hotbar():
    for i in range(9):
        var slot = hotbar.get_child(i)
        slot.set_item(InventoryManager.get_hotbar_item(i))

func setup_inventory():
    for i in range(27):
        var slot = inventory_grid.get_child(i)
        slot.set_item(InventoryManager.get_inventory_item(i))

func update_inventory():
    for i in range(9):
        var slot = hotbar.get_child(i)
        InventoryManager.set_hotbar_item(i, slot.item)

    for i in range(27):
        var slot = inventory_grid.get_child(i)
        InventoryManager.set_inventory_item(i, slot.item)
