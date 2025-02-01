extends Node

class ItemRow:
	var slots: Array[Item] = []

	func _init(size: int):
		for i in range(size):
			slots.append(null)