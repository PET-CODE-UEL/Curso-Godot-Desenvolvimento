extends CanvasLayer

@onready var corn_amount = $CornAmount
@onready var prompt = $Prompt

func update_prompt_text(new_text : String):
	prompt.text = new_text

func update_crop_amount(crop_type, new_amount : int):
	match crop_type:
		CropTypes.CROP_TYPE.CORN:
			corn_amount.text = "Corn: " + str(new_amount)
