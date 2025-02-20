extends Control

@onready var prompt: Label = $Prompt

@onready var hotbar: Node = $Margin/Margin/Hotbar

func get_hotbar():
	return hotbar
