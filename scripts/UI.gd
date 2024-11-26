extends CanvasLayer

@onready var corn_amount = $CornAmount
@onready var prompt = $Prompt

func update_prompt_text(new_text : String):
	prompt.text = new_text

func update_corn_amount(new_text : int):
	corn_amount.text = str(new_text)  # Converte para string antes de atualizar
