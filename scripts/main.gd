class_name Main
extends Node3D

@onready var pause_menu: Control = $PauseMenu
@onready var player: Player = $Player

func _ready() -> void:
	pause_menu.hide()
	
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if pause_menu.is_visible():
			_resume_game()
		else:
			_pause_game()

func _resume_game() -> void:
	pause_menu.hide()
	get_tree().paused = false
	player._resume_game()
	

func _pause_game() -> void:
	pause_menu.show()
	get_tree().paused = true
	player._pause_game()
	

	
