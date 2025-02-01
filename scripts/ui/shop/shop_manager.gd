extends Node

signal money_updated(new_money)
signal shop_updated

var player_money: int = 100  # Dinheiro inicial do jogador
var shop_items: Array[Item] = []

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

func add_item_to_shop(item: Item):
    shop_items.append(item)
    shop_updated.emit()

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