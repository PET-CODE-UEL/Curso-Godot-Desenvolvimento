extends Node

# Armazena os itens da hotbar e do inventário
const INVENTORY_SIZE := 27
const HOTBAR_SIZE := 9
var inventory_items : Array[Item] = []
var hotbar_items : Array[Item] = []


func initialize_inventory():
	inventory_items = []
	for i in range(INVENTORY_SIZE):
		inventory_items.append(null)
	for i in range(HOTBAR_SIZE):
		hotbar_items.append(null)


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


# Função para salvar inventário e hotbar
func save() -> Dictionary:
	var inventory_data := {}
	inventory_data["inventory"] = []
	for item in inventory_items:
		if item != null:
			inventory_data["inventory"].append({"name": item.name, "quantity": item.quantity})
	inventory_data["hotbar"] = []
	for item in hotbar_items:
		if item != null:
			inventory_data["hotbar"].append({"name": item.name, "quantity": item.quantity})
	return inventory_data


# Função para carregar o inventário e a hotbar
func load(inventory_data: Dictionary):
	# Carregar inventário
	for item_data in inventory_data["inventory"]:
		var item = load("res://itens/" + item_data["name"] + ".tres")
		item.quantity = item_data["quantity"]
		add_item_to_inventory(item)

	# Carregar hotbar
	for i in range(HOTBAR_SIZE):
		if i < inventory_data["hotbar"].size():
			var item_data = inventory_data["hotbar"][i]
			var item = load("res://itens/" + item_data["name"] + ".tres")
			item.quantity = item_data["quantity"]
			hotbar_items[i] = item  # Coloca o item diretamente na hotbar


# Função para adicionar um item ao inventário
func add_item_to_inventory(new_item: Item) -> bool:
	for i in range(inventory_items.size()):
		var existing_item = inventory_items[i]
		if (
			existing_item
			and existing_item.name == new_item.name
			and existing_item.quantity < existing_item.max_stack
		):
			var available_space = existing_item.max_stack - existing_item.quantity
			var quantity_to_add = min(new_item.quantity, available_space)
			existing_item.quantity += quantity_to_add
			new_item.quantity -= quantity_to_add
			if new_item.quantity <= 0:
				return true  # Todo o item foi adicionado

	# Caso não tenha espaço para empilhar, tenta encontrar um slot vazio
	for i in range(inventory_items.size()):
		if inventory_items[i] == null:
			inventory_items[i] = new_item.clone()
			return true  # Item adicionado em um slot vazio

	return false  # Inventário cheio


# Função para remover um item do inventário
func remove_item_from_inventory(item_name: String, quantity: int) -> bool:
	for i in range(inventory_items.size()):
		var existing_item = inventory_items[i]
		if existing_item and existing_item.name == item_name:
			if existing_item.quantity >= quantity:
				existing_item.quantity -= quantity
				if existing_item.quantity == 0:
					inventory_items[i] = null  # Remove o slot se a quantidade chegar a 0
				return true  # Quantidade removida com sucesso
			quantity -= existing_item.quantity
			inventory_items[i] = null  # Remove o slot
	return false  # Não foi possível remover a quantidade total
