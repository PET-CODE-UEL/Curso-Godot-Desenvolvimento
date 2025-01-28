extends TextureButton

var item: Item = null
@onready var quantity_label = $ItemQuantity

func set_item(new_item: Item):
    if new_item:
        item = new_item.clone()
        texture_normal = item.texture  # Exibe a textura do item
        quantity_label.text = str(item.quantity)  # Exibe a quantidade
        quantity_label.visible = item.quantity > 1  # Exibe a quantidade apenas se maior que 1
    else:
        clear_item()

func clear_item():
    item = null
    texture_normal = null
    quantity_label.text = ""
    quantity_label.visible = false

func _gui_input(event):
    if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
        if item:
            get_tree().set_drag_preview(texture_normal)  # Define o preview do item ao arrastar
            set_drag_data(item)  # Define os dados para o drag-and-drop
            clear_item()

func set_drag_data(data):
    set_meta("drag_data", data)

func can_drop_data(_position, data):
    return data is Item  # Verifica se os dados são do tipo Item

func drop_data(_position, data):
    if item:
        var temp = item
        set_item(data)
        return temp
    set_item(data)
