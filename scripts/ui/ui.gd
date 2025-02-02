extends CanvasLayer

@export var player: Player
@onready var pause_menu: Control = $PauseMenu

func _ready() -> void:
	pause_menu.hide()

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if player.inventory_open:
			player.toggle_inventory()
		elif pause_menu.is_visible():
			_resume_game()
		else:
			_pause_game()


func _resume_game() -> void:
	player.resume_game()
	pause_menu.hide()
	get_tree().paused = false


func _pause_game() -> void:
	player.pause_game()
	pause_menu.show()
	get_tree().paused = true