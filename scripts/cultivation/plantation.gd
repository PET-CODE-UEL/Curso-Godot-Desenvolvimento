extends StaticBody3D

var occupied = false # VE SE O SOLO JA TEM UMA PLANTA (1 PLATA POR SOLO)
var crop: Node = null # REFERENCIA A PLANTA DESSE SOLO
var fertilized = false # CHECA SE JA FERTILIZOU NESTE DIA

func update_prompt_text(): # INTERFACE DO JOGO
	if !fertilized: 
		return "Press F to Fertilize "
	else: 
		if !occupied:
			return "Click MOUSE 1 to Plant"
		return ""
