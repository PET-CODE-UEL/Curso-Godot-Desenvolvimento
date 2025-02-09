class_name Game
extends Node3D

@onready var player : Player = $Player

func _ready() -> void:
	SaveLoad.initialize(self)