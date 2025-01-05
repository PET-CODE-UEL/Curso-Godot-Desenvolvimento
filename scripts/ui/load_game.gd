extends Control

func _on_back_pressed() -> void:
	var main_menu : MainMenu = get_parent().get_parent()
	main_menu.set_button_menu(true)

func _on_load_pressed() -> void:
	pass # Replace with function body.
