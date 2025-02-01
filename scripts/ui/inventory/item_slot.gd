class_name ItemSlot
extends Button

var item: Item = null
var slot_index: int = -1
@onready var item_icon = $Margin/ItemIcon
@onready var quantity_label = $ItemQuantity

func set_item(new_item: Item):
	if new_item:
		item = new_item.clone()
		item_icon.texture = item.texture # Define o ícone do item
		quantity_label.text = str(item.quantity) # Exibe a quantidade
		quantity_label.visible = item.quantity > 1 # Só exibe se for maior que 1
	else:
		clear_item()

func clear_item():
	item = null
	item_icon.texture = null
	quantity_label.text = ""
	quantity_label.visible = false

func _input(event):
	if event is InputEventMouseButton and event.is_released():
		var drop_success = false

		for slot in get_tree().get_nodes_in_group("inventory_slots"):
			if slot.is_drag_successful():
				drop_success = true
				break

		# Se o drop falhou, restaura o item no slot original
		if not drop_success:
			_restore_item()

# Drag & Drop
func _get_drag_data(_position):
	if item:
		var preview = TextureRect.new()
		preview.texture = item_icon.texture # Usa o ícone do item
		preview.custom_minimum_size = Vector2(32, 32) # Ajusta o tamanho do preview
		preview.modulate.a = 0.8 # Transparência no preview
		set_drag_preview(preview)
		clear_item()
		return self
	return null

func _can_drop_data(_position, data):
	return data is ItemSlot

func _drop_data(_position, data):
	var src_slot: ItemSlot = data
	var dst_slot: ItemSlot = self

	if not src_slot or not dst_slot:
		return

	# Se estiver arrastando um item do inventário para a loja -> VENDA
	if src_slot.is_in_group("inventory_slots") and dst_slot.is_in_group("shop_slots"):
		if ShopManager.sell_item(src_slot.item):
			src_slot.clear_item()

	# Se estiver arrastando um item da loja para o inventário -> COMPRA
	elif src_slot.is_in_group("shop_slots") and dst_slot.is_in_group("inventory_slots"):
		if ShopManager.buy_item(src_slot.item):
			dst_slot.set_item(src_slot.item.clone())

	# Se esiver arrastando um item do inventário para o inventário -> TROCA
	elif src_slot.is_in_group("inventory_slots") and dst_slot.is_in_group("inventory_slots"):
		InventoryManager.swap_items(src_slot.slot_index, dst_slot.slot_index)


func _restore_item():
	if is_in_group("inventory_slots"):
		set_item(InventoryManager.get_inventory_item(slot_index))
	elif is_in_group("shop_slots"):
		set_item(ShopManager.get_shop_item(slot_index))
