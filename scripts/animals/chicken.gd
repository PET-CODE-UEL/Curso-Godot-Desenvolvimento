extends CharacterBody3D

var speed = 3.0
var move_duration = 2.0
var gravity = -9.8
@export var egg_interval = 5

var move_direction = Vector3.ZERO
var move_timer = 0.0
var egg_timer = 0.0

func _ready():
	randomize()
	pick_random_direction()
	egg_timer = egg_interval

func _process(delta):
	egg_timer -= delta
	if egg_timer <= 0:
		var inventory_manager = get_node("/root/InventoryManager")
		var egg_resource = load("res://resources/items/ovo.tres")
		var egg_item = egg_resource.duplicate()
		inventory_manager.add_item_to_inventory(egg_item)
		egg_timer = egg_interval

func _physics_process(delta):
	move_timer -= delta

	if move_timer <= 0:
		pick_random_direction()

	velocity.x = move_direction.x * speed
	velocity.z = move_direction.z * speed
	
	if move_direction != Vector3.ZERO:
		look_at(global_position + move_direction, Vector3.UP)

	velocity.y += gravity * delta
	move_and_slide()

func pick_random_direction():
	move_timer = randf_range(1.0, move_duration)
	if move_timer < 1.5:
		move_direction = Vector3.ZERO
	else:
		move_direction = Vector3(
			randf_range(-1, 1),
			0,
			randf_range(-1, 1)
		).normalized()

func randf_range(min_val: float, max_val: float) -> float:
	return min_val + randf() * (max_val - min_val)
