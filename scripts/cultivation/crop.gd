extends StaticBody3D

@export var crop_type: CropTypes.CROP_TYPE # TIPO DE PLANTA A SER USADA
@export var harvest_amount = 1 # QUANTIDADE QUE DROPA

# FASES DO SPRITE DA PLANTA
@onready var large = $Large
@onready var medium = $Medium
@onready var small = $Small
# VALUE EH O MOMENTO ATUAL DA PLANTA E TIME E O TEMPO TOTAL QUE LEVA PARA CRESCER
var growth_value = 0.0
var growth_time = 30

var watered = false # CHECA SE JA FOI REGADA HOJE
var harvestable = false # CHECA SE JA PODE COLHER
var plantation: Node = null # REFERENCIA O SOLO EM QUE FOI PLANTADA

func get_harvest_amount():
	return harvest_amount
	
func get_crop_type():
	return crop_type

func interact():
	if harvestable: # DESTROI INSTANCIA APOS COLHER
		queue_free()

func update_prompt_text(): # INTERFACE DO JOGO
	if harvestable:
		return "Click MOUSE 2 to Harvest"
	else :
		if !watered:
			return "Press R to Water"
		return ""

# PROCESSA CRESCIMENTO DA PLANTA
func _process(delta):
	if growth_value < 1.0: # ESSE VALOR EH PORCENTAGEM QUE A PLANTA JA CRESCEU
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
