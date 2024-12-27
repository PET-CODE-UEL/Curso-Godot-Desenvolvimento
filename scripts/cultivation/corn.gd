extends StaticBody3D

@export var harvest_amount = 1

@onready var large = $Large
@onready var medium = $Medium
@onready var small = $Small

var growth_value = 0.0
@export var growth_time = 10

var harvestable = false

func get_harvest_amount():
	return harvest_amount

func interact():
	if harvestable:
		queue_free()

func update_prompt_text():
	if harvestable:
		return "Click to harvest"
	else:
		return "Not ready"

func _process(delta):
	if growth_value < 1.0:
		growth_value += delta / growth_time

	# Ajustar visibilidade com base no crescimento
	small.visible = growth_value < 0.5
	medium.visible = growth_value >= 0.5 and growth_value < 1.0
	large.visible = growth_value >= 1.0

	# Controlar lógica de colisionabilidade ou processamento (exemplo para StaticBody3D)
	small.set_physics_process(growth_value < 0.5)
	medium.set_physics_process(growth_value >= 0.5 and growth_value < 1.0)
	large.set_physics_process(growth_value >= 1.0)

	# Determinar se está colhível
	harvestable = growth_value >= 1.0
