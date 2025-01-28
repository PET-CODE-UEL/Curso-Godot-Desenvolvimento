extends Control

@export var slot_scene: PackedScene
@onready var hotbar = $Margin/Panel/Margin/VBox/Hotbar
@onready var inventory_grid = $Margin/Panel/Margin/VBox/InventoryGrid

func _ready():
    refresh_ui()

func setup_hotbar():
    clear_children(hotbar)  # Limpa os slots existentes
    for i in range(InventoryManager.HOTBAR_SIZE):
        var slot = slot_scene.instantiate()  # Instancia o slot
        hotbar.add_child(slot)  # Adiciona o slot à hotbar
        slot.set_item(InventoryManager.get_hotbar_item(i))  # Define o item da hotbar

func setup_inventory():
    clear_children(inventory_grid)  # Limpa os slots existentes
    for i in range(InventoryManager.INVENTORY_SIZE):
        var slot = slot_scene.instantiate()  # Instancia o slot
        inventory_grid.add_child(slot)  # Adiciona o slot ao inventário
        slot.set_item(InventoryManager.get_inventory_item(i))  # Define o item do inventário

func update_inventory():
    for i in range(InventoryManager.HOTBAR_SIZE):
        var slot = hotbar.get_child(i)
        InventoryManager.set_hotbar_item(i, slot.item)

    for i in range(InventoryManager.INVENTORY_SIZE):
        var slot = inventory_grid.get_child(i)
        InventoryManager.set_inventory_item(i, slot.item)

func clear_children(node: Node):
    for child in node.get_children():
        child.queue_free()

func refresh_ui():
    setup_hotbar()
    setup_inventory()