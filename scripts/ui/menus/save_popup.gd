class_name SavePopup
extends Control

signal save_completed(save_name)

@onready var line_edit: LineEdit = $Center/Panel/VBox/LineEdit

func _on_save_pressed() -> void:
	var save_name = line_edit.text.strip_edges()
	if save_name == "":
		print("Informe um nome válido para o save!")
		return
	SaveLoad.save_game(save_name)
	save_completed.emit(save_name)
	hide()

func _on_cancel_pressed() -> void:
	hide()
