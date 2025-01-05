extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_resume_pressed() -> void:
	get_parent()._resume_game()	


func _on_options_pressed() -> void:
	pass # Replace with function body.


func _on_menu_exit_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")


func _on_desktop_exit_pressed() -> void:
	get_tree().quit()
