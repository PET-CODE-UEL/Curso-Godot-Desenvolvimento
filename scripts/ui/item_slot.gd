extends TextureButton


var item_data: Dictionary = {}

func set_item(item: Dictionary):
	item_data = item
	texture_normal = item_data.icon
	if $ItemQuantity:
		$ItemQuantity.text = str(item_data.quantity) if item_data.has("quantity") else ""

func _on_pressed() -> void:
	print("Item clicado: ", item_data.name)
