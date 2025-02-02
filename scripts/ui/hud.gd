extends Control

@onready var prompt = $Prompt

func update_prompt_text(new_text : String):
	prompt.text = new_text

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
