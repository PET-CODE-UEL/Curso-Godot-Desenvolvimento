class_name Main
extends Node

@onready var pause_menu: Control = $PauseMenu
@onready var player: Player = $Game/Player


func _ready() -> void:
	pause_menu.hide()


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if pause_menu.is_visible():
			_resume_game()
		else:
			_pause_game()


func _resume_game() -> void:
	player._resume_game()
	pause_menu.hide()
	get_tree().paused = false


func _pause_game() -> void:
	player._pause_game()
	pause_menu.show()
	get_tree().paused = true
