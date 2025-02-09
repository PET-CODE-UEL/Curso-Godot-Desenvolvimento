class_name Game
extends Node3D

@onready var player : Player = $Player

func _ready() -> void:
	SaveLoad.initialize(self)
	if SaveLoad.pending_save_name != "":
		SaveLoad.load_game(SaveLoad.pending_save_name)
		SaveLoad.pending_save_name = ""
