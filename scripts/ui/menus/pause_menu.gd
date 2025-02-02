extends Control

func _on_resume_pressed() -> void:
	get_parent()._resume_game()	


func _on_options_pressed() -> void:
	pass # Replace with function body.


func _on_menu_exit_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")


func _on_desktop_exit_pressed() -> void:
	get_tree().quit()
