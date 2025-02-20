class_name Player
extends CharacterBody3D

# Movimentação
const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Movimentação da Câmera
@export var mouse_sensitivity := Vector2(0.01, 0.01)
var rotation_horizontal := 0.0
var rotation_vertical := 0.0

# Câmeras
enum CameraModes {
	FIRST_PERSON,
	SECOND_PERSON,
	THIRD_PERSON,
}

var current_camera_mode: CameraModes = CameraModes.FIRST_PERSON

@onready var camera_pivot: Node3D = $CameraPivot
@onready var first_person: Camera3D = $CameraPivot/FirstPerson
@onready var second_person: Camera3D = $CameraPivot/SecondPerson
@onready var third_person: Camera3D = $CameraPivot/ThirdPerson

# Animação
@onready var animation_tree: AnimationTree = $"CollisionShape3D/PlayerModel/Armação/AnimationTree"
@onready var skeleton: Skeleton3D = $"CollisionShape3D/PlayerModel/Armação/Skeleton3D"
@onready var head_bone := skeleton.find_bone("Coluna Superior")
@onready var hand_anim_tree : AnimationTree = $Hand/AnimationTree
@onready var hand_anim_state: AnimationNodeStateMachinePlayback = hand_anim_tree.get("parameters/playback")

#----------------------------- Interação -------------------------------------------
@onready var interacter = $Interacter


func _ready():
	await get_tree().process_frame  # Aguarda um frame para garantir que a HUD foi carregada
	#print_tree_structure()  # 🔥 Mostra toda a árvore de nós
	update_camera_mode()
	interacter.connect("update_prompt_text", UIManager.update_prompt_text)

#------------------------------------------------------------------------------------

func print_tree_structure(node: Node = get_tree().current_scene, indent: String = ""):
	print(indent + node.name)  # Exibe o nome do nó com indentação
	for child in node.get_children():
		print_tree_structure(child, indent + "  ")  # Chama recursivamente para os filhos


func _process(_delta):
	rotation.y = rotation_horizontal
	camera_pivot.rotation.x = rotation_vertical
	var current_pose := skeleton.get_bone_pose(head_bone)
	current_pose.basis = Basis.from_euler(Vector3(-rotation_vertical, 0, 0))
	skeleton.set_bone_pose(head_bone, current_pose)

func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotation_horizontal -= event.relative.x * mouse_sensitivity.x
		rotation_vertical -= event.relative.y * mouse_sensitivity.y
		rotation_vertical = clamp(rotation_vertical, deg_to_rad(-90), deg_to_rad(90))

	if event.is_action_pressed("camera_switch"):
		cycle_camera_mode()

	if event.is_action_pressed("inventory_toggle"):
		UIManager.toggle_inventory()

	if event.is_action_pressed("shop_toggle"):
		UIManager.toggle_shop()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		set_walk(true)
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		set_walk(false)
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func set_walk(value: bool):
	animation_tree["parameters/conditions/walking"] = value
	animation_tree["parameters/conditions/idle"] = not value
	hand_anim_tree["parameters/conditions/walking"] = value
	hand_anim_tree["parameters/conditions/idle"] = not value
	
	
func cycle_camera_mode():
	var camera_modes := CameraModes.values()
	current_camera_mode = camera_modes[(int(current_camera_mode) + 1) % camera_modes.size()]
	update_camera_mode()

func update_camera_mode():
	first_person.current = (current_camera_mode == CameraModes.FIRST_PERSON)
	second_person.current = (current_camera_mode == CameraModes.SECOND_PERSON)
	third_person.current = (current_camera_mode == CameraModes.THIRD_PERSON)
	toggle_visibility(current_camera_mode == CameraModes.FIRST_PERSON)

func toggle_visibility(is_first_person: bool):
	for child in skeleton.get_children():
		if child is MeshInstance3D:
			if not is_first_person:
				child.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_ON
			else:
				child.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_SHADOWS_ONLY
