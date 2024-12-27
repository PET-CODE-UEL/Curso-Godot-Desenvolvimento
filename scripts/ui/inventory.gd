extends Node3D

var corn_amount = 0
signal inventory_updated

func add_corn(amount_to_add : int):
	corn_amount += amount_to_add
	emit_signal("inventory_updated", corn_amount)  # Nome do sinal ajustado
