extends Node

signal money_updated(new_money) # Emite quando o money for alterado
signal shop_updated # Emite quando o shop for alterado

const ROWS := 3
const COLUMNS := 9
const SHOP_SIZE := ROWS * COLUMNS

var shop_items: Array[Utils.ItemRow] = []
var player_money: int = 100  # Dinheiro inicial do jogador

func _init():
	for i in range(ROWS):
		shop_items.append(Utils.ItemRow.new(COLUMNS))
	load_items_to_shop()

func load_items_to_shop():
	var items: Array[Item] = load("res://resources/shop/shop_items.tres").items
	var item_index := 0
	for row in range(ROWS):
		for col in range(COLUMNS):
			if item_index < items.size():
				shop_items[row].slots[col] = items[item_index]
				item_index += 1
			else:
				break
	shop_updated.emit()

func set_money(amount: int):
	player_money = max(0, amount)
	money_updated.emit(player_money)

func add_money(amount: int):
	set_money(player_money + amount)

func remove_money(amount: int) -> bool:
	if player_money >= amount:
		set_money(player_money - amount)
		return true
	return false

func buy_item(item: Item) -> bool:
	if remove_money(item.price):
		var new_item = item.clone()
		InventoryManager.add_item_to_inventory(new_item)
		return true
	return false

func sell_item(item: Item) -> bool:
	if InventoryManager.remove_item_from_inventory(item.name, 1):
		add_money(item.price)
		return true
	return false
