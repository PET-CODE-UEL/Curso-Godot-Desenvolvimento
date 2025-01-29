extends Node

signal inventory_updated # Emite quando o inventário for alterado
signal hotbar_updated # Emite quando a hotbar for alterada

# Armazena os itens da hotbar e do inventário
const INVENTORY_SIZE := 27
const HOTBAR_SIZE := 9
var inventory_items: Array[Item] = []
var hotbar_items: Array[Item] = []

func _init():
	for i in range(INVENTORY_SIZE):
		inventory_items.append(null)
	for i in range(HOTBAR_SIZE):
		hotbar_items.append(null)

func get_inventory_item(slot_index: int) -> Item:
	if slot_index >= 0 and slot_index < inventory_items.size():
		return inventory_items[slot_index]
	return null

func set_inventory_item(slot_index: int, item: Item):
	if slot_index >= 0 and slot_index < inventory_items.size():
		inventory_items[slot_index] = item

func get_hotbar_item(slot_index: int) -> Item:
	if slot_index >= 0 and slot_index < hotbar_items.size():
		return hotbar_items[slot_index]
	return null

func set_hotbar_item(slot_index: int, item: Item):
	if slot_index >= 0 and slot_index < hotbar_items.size():
		hotbar_items[slot_index] = item

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
			hotbar_items[i] = item # Coloca o item diretamente na hotbar

# Procura e empilha um item no inventário
func search_and_stack(new_item: Item, inventory_array: Array[Item], inventory_signal: Signal):
	for i in range(inventory_array.size()):
		var existing_item := inventory_array[i]
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
				inventory_signal.emit()
				return true
	return false

# Adiciona o item em um slot vazio
func add_to_empty_slot(new_item: Item, inventory_array: Array[Item], inventory_signal: Signal):
	for i in range(inventory_array.size()):
		if inventory_array[i] == null:
			inventory_array[i] = new_item.clone()
			inventory_signal.emit()
			return true
	return false

# Função para adicionar um item ao inventário
func add_item_to_inventory(new_item: Item) -> bool:
	# Procura no inventário um item igual para empilhar
	if search_and_stack(new_item, inventory_items, inventory_updated):
		return true

	# Procura na hotbar um item igual para empilhar
	if search_and_stack(new_item, hotbar_items, hotbar_updated):
		return true

	# Caso não tenha espaço para empilhar, tenta encontrar um slot vazio no inventário
	if add_to_empty_slot(new_item, inventory_items, inventory_updated):
		return true

	# Caso não tenha espaço para empilhar, tenta encontrar um slot vazio no hotbar
	if add_to_empty_slot(new_item, hotbar_items, inventory_updated):
		return true

	# Inventário cheio
	return false


# Função para remover um item do inventário e da hotbar
func remove_item_from_inventory(item_name: String, quantity: int) -> bool:
	var total_quantity_available := 0
	var slots_to_remove := []

	# Verifica a quantidade total disponível no inventário
	for i in range(inventory_items.size()):
		var item = inventory_items[i]
		if item and item.name == item_name:
			total_quantity_available += item.quantity
			slots_to_remove.append(["inventory", i])  # Salvar posição para remoção futura

	# Verifica a quantidade total disponível na hotbar
	for i in range(hotbar_items.size()):
		var item = hotbar_items[i]
		if item and item.name == item_name:
			total_quantity_available += item.quantity
			slots_to_remove.append(["hotbar", i])  # Salvar posição para remoção futura

	# Se não houver quantidade suficiente, retorna false
	if total_quantity_available < quantity:
		return false

	# Remover os itens
	while !slots_to_remove.is_empty():
		var slot = slots_to_remove.pop_back()
		var slot_type = slot[0]
		var index = slot[1]
		if slot_type == "inventory":
			var item := inventory_items[index]
			if item.quantity > quantity:
				item.quantity -= quantity
				inventory_updated.emit()
				return true

			quantity -= item.quantity
			inventory_items[index] = null

		elif slot_type == "hotbar":
			var item := hotbar_items[index]
			if item.quantity > quantity:
				item.quantity -= quantity
				hotbar_updated.emit()
				return true

			quantity -= item.quantity
			hotbar_items[index] = null

	inventory_updated.emit()
	hotbar_updated.emit()
	return true  # Remoção concluída com sucesso

