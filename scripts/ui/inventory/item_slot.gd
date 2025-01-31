extends Button

var item: Item = null
var slot_index: int = -1
@onready var item_icon = $Margin/ItemIcon
@onready var quantity_label = $ItemQuantity

func set_item(new_item: Item):
	if new_item:
		item = new_item.clone()
		item_icon.texture = item.texture  # Define o ícone do item
		quantity_label.text = str(item.quantity)  # Exibe a quantidade
		quantity_label.visible = item.quantity > 1  # Só exibe se for maior que 1
	else:
		clear_item()

func clear_item():
	item = null
	item_icon.texture = null
	quantity_label.text = ""
	quantity_label.visible = false

func _input(event):
	if event is InputEventMouseButton and not event.pressed:
		# Quando o botão do mouse é solto, verifica se o drop falhou
		for slot in get_tree().get_nodes_in_group("inventory_slots"):
			if slot.is_drag_successful():
				return

		# Se chegou aqui, significa que o drop falhou
		for slot in get_tree().get_nodes_in_group("inventory_slots"):
			slot.drop_data_failed()

# Drag & Drop
func _get_drag_data(_position):
	if item:
		var preview = TextureRect.new()
		preview.texture = item_icon.texture  # Usa o ícone do item
		preview.custom_minimum_size = Vector2(32, 32)  # Ajusta o tamanho do preview
		preview.modulate.a = 0.8  # Transparência no preview
		set_drag_preview(preview)
		clear_item()
		return slot_index
	return null

func _can_drop_data(_position, src_index):
	return src_index is int

func _drop_data(_position, src_index):
	if src_index > -1:
		InventoryManager.swap_items(src_index, slot_index)

func drop_data_failed():
	set_item(InventoryManager.get_inventory_item(slot_index))