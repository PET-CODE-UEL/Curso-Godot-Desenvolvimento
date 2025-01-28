extends Node

# Armazena os itens da hotbar e do inventário
var hotbar_items := [null, null, null, null, null, null, null, null, null]  # 9 slots
var inventory_items := []  # Slots do inventário principal

func initialize_inventory(size: int):
    inventory_items = []
    for i in range(size):
        inventory_items.append(null)

func get_hotbar_item(slot_index: int) -> Item:
    if slot_index >= 0 and slot_index < hotbar_items.size():
        return hotbar_items[slot_index]
    return null

func set_hotbar_item(slot_index: int, item: Item):
    if slot_index >= 0 and slot_index < hotbar_items.size():
        hotbar_items[slot_index] = item

func get_inventory_item(slot_index: int) -> Item:
    if slot_index >= 0 and slot_index < inventory_items.size():
        return inventory_items[slot_index]
    return null

func set_inventory_item(slot_index: int, item: Item):
    if slot_index >= 0 and slot_index < inventory_items.size():
        inventory_items[slot_index] = item
