extends Node3D

var corn_amount = 0
signal inventory_updated

func add_crop(crop_type, amount_to_add : int):
	
	var new_total
	match crop_type:
		CropTypes.CROP_TYPE.CORN:
			corn_amount += amount_to_add
			new_total = corn_amount
			
	emit_signal("inventory_updated", crop_type,new_total)
