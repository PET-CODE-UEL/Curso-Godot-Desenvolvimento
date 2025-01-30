extends Button

var item: Item = null
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
	item_icon.texture = null  # Limpa o ícone ao invés de usar texture_normal
	quantity_label.text = ""
	quantity_label.visible = false

# Drag & Drop
func _get_drag_data(_position):
	if item:
		var preview = TextureRect.new()
		preview.texture = item_icon.texture  # Usa o ícone do item
		preview.custom_minimum_size = Vector2(32, 32)  # Ajusta o tamanho do preview
		preview.modulate.a = 0.8  # Transparência no preview
		set_drag_preview(preview)

		var data = item  # Define os dados do item arrastado
		clear_item()  # Remove o item do slot
		return data
	return null

func _can_drop_data(_position, data):
	return data is Item  # Só aceita dados que sejam um Item

func _drop_data(_position, data):
	if item:  # Se já houver um item no slot, troca eles
		var temp = item
		set_item(data)
		return temp
	set_item(data)
