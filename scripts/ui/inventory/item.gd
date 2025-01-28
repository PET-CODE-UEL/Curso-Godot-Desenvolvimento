class_name Item
extends Resource

@export var name: String = ""
@export var texture: Texture2D = null
@export var max_stack: int = 64
@export var description: String = ""
@export var quantity: int = 1

func clone() -> Item:
    # Cria uma cópia deste item
    var new_item = Item.new()
    new_item.name = name
    new_item.texture = texture
    new_item.max_stack = max_stack
    new_item.description = description
    new_item.quantity = quantity
    return new_item
