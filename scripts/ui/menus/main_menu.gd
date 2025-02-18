class_name MainMenu
extends Control

@onready var button_menu: VBoxContainer = $DynamicContent/ButtonMenu

func _on_new_game_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_scene.tscn")

func _on_load_game_pressed() -> void:
	set_button_menu(false)

func _on_exit_pressed() -> void:
	get_tree().quit()

func set_button_menu(show_menu: bool):
	if show_menu:
		button_menu.show()
	else:
		button_menu.hide()
