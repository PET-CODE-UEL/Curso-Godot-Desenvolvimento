extends Control

func _on_resume_pressed() -> void:
	UIManager.toggle_pause()

func _on_menu_exit_pressed() -> void:
	var save_popup = UIManager.ui.save_popup
	save_popup.show()
	save_popup.save_completed.connect(menu_exit)

func _on_desktop_exit_pressed() -> void:
	var save_popup = UIManager.ui.save_popup
	save_popup.show()
	save_popup.save_completed.connect(desktop_exit)

func menu_exit(save_name: String) -> void:
	UIManager.force_unpause()
	get_tree().change_scene_to_file("res://scenes/ui/menus/main_menu.tscn")
	print("Save '%s' concluído e saindo para o menu." % save_name)

func desktop_exit(_save_name: String) -> void:
	get_tree().quit()
