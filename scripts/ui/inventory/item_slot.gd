extends TextureButton

# Dados do item neste slot
var item_data: Dictionary = {}
@onready var quantity_label = $ItemQuantity

func set_item(data: Dictionary):
	item_data = data
	if item_data:
		texture_normal = load(item_data.get("icon", "res://assets/icons/default_icon.png"))
		quantity_label.text = str(item_data.get("quantity", 1))
		quantity_label.visible = item_data.get("quantity", 1) > 1
	else:
		clear_item()

func clear_item():
	item_data = {}
	texture_normal = null
	quantity_label.text = ""
	quantity_label.visible = false

# Para implementar arrastar e soltar
func _gui_input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		if item_data:
			get_tree().set_drag_preview(self.texture_normal)
			set_drag_data(item_data)
			clear_item()

func can_drop_data(position, data):
	return data.has("name")  # Confirma se os dados do item são válidos.

func drop_data(position, data):
	if item_data:
		# Troca de itens entre os slots
		var temp = item_data
		set_item(data)
		return temp
	else:
		set_item(data)
