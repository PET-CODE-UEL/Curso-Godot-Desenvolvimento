extends Node

signal inventory_updated  # Emite quando o inventário for alterado

const ROWS := 4
const COLUMNS := 9
const INVENTORY_SIZE := (ROWS - 1) * COLUMNS
const HOTBAR_SIZE := 1 * COLUMNS

class InventoryRow:
	var slots: Array[Item] = []

	func _init(size: int):
		for i in range(size):
			slots.append(null)

var inventory_items: Array[InventoryRow] = []

func _init():
	for i in range(ROWS):
		inventory_items.append(InventoryRow.new(COLUMNS))

func get_inventory_item(slot_index: int) -> Item:
	var row = floor(slot_index / float(COLUMNS))
	var col = slot_index % COLUMNS
	if row >= 0 and row < ROWS and col >= 0 and col < COLUMNS:
		return inventory_items[row].slots[col]
	return null

func set_inventory_item(slot_index: int, item: Item):
	var row = floor(slot_index / float(COLUMNS))
	var col = slot_index % COLUMNS
	if row >= 0 and row < ROWS and col >= 0 and col < COLUMNS:
		inventory_items[row].slots[col] = item
		inventory_updated.emit()

func get_hotbar_item(index: int) -> Item:
	if index >= 0 and index < HOTBAR_SIZE:
		return inventory_items[ROWS - 1].slots[index]
	return null

func set_hotbar_item(index: int, item: Item):
	if index >= 0 and index < HOTBAR_SIZE:
		inventory_items[ROWS - 1].slots[index] = item
		inventory_updated.emit()

func swap_items(src_index, dst_index):
	var src_item = get_inventory_item(src_index)
	var src_row = floor(src_index / float(COLUMNS))
	var src_col = src_index % COLUMNS
	var dst_item = get_inventory_item(dst_index)
	var dst_row = floor(dst_index / float(COLUMNS))
	var dst_col = dst_index % COLUMNS
	if src_item != null or dst_item != null:
		inventory_items[dst_row].slots[dst_col] = src_item
		inventory_items[src_row].slots[src_col] = dst_item
		inventory_updated.emit()

# Função para salvar o inventário
func save() -> Dictionary:
	var inventory_data := {}
	inventory_data["inventory"] = []

	# Salvando cada slot da matriz
	for row in inventory_items:
		for item in row.slots:
			if item != null:
				inventory_data["inventory"].append({"name": item.name, "quantity": item.quantity})

	return inventory_data


# Função para carregar o inventário
func load(inventory_data: Dictionary):
	var item_index = 0

	for row in inventory_items:
		for col in range(COLUMNS):
			if item_index < inventory_data["inventory"].size():
				var item_data = inventory_data["inventory"][item_index]
				var item = load("res://itens/" + item_data["name"] + ".tres")
				item.quantity = item_data["quantity"]
				row.slots[col] = item
				item_index += 1


# Função para adicionar um item ao inventário
func add_item_to_inventory(new_item: Item) -> bool:
	# Procura no inventário um item igual para empilhar
	for row in inventory_items:
		for i in range(row.slots.size()):
			var existing_item := row.slots[i]
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
					inventory_updated.emit()
					return true

	# Caso não tenha espaço para empilhar, tenta encontrar um slot vazio no inventário
	for row in inventory_items:
		for i in range(row.slots.size()):
			if row.slots[i] == null:
				row.slots[i] = new_item.clone()
				inventory_updated.emit()
				return true

	# Inventário cheio
	return false


# Função para remover um item do inventário
func remove_item_from_inventory(item_name: String, quantity: int) -> bool:
	var total_quantity_available := 0
	var slots_to_remove := []

	# Verifica a quantidade total disponível no inventário
	for row in inventory_items:
		for col in range(row.slots.size()):
			var item = row.slots[col]
			if item and item.name == item_name:
				total_quantity_available += item.quantity
				slots_to_remove.append([row, col])

	# Se não houver quantidade suficiente, retorna false
	if total_quantity_available < quantity:
		return false

	# Remover os itens
	while !slots_to_remove.is_empty():
		var slot = slots_to_remove.pop_back()
		var row : InventoryRow = slot[0]
		var index : int = slot[1]
		var item := row.slots[index]
		if item.quantity > quantity:
			item.quantity -= quantity
			inventory_updated.emit()
			return true
		quantity -= item.quantity
		row.slots[index] = null

	inventory_updated.emit()
	# Remoção concluída com sucesso
	return true
