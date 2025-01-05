extends Node

var save_data = {}

func save_game(slot: int) -> void:
	var file = FileAccess.open("user://save_slot_%d.save" % slot, FileAccess.WRITE)
	file.store_var(save_data)
	file.close()

func load_game(slot: int) -> void:
	var file = FileAccess.open("user://save_slot_%d.save" % slot, FileAccess.READ)
	save_data = file.get_var()
	file.close()

func has_save(slot: int) -> bool:
	return FileAccess.file_exists("user://save_slot_%d.save" % slot)
