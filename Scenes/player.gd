
extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -400.0

var direction = 1
var wall_waiting = false
var wall_direction = 0


func _physics_process(delta: float) -> void:
	# Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Wall jump OR automatic jump on landing
	if wall_waiting:
		if Input.is_action_pressed("jump") or is_on_floor():
			velocity.y = JUMP_VELOCITY
			direction = wall_direction
			wall_waiting = false

	# Normal jump
	elif Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Movement
	if wall_waiting:
		velocity.x = 0
	else:
		velocity.x = SPEED * direction

	move_and_slide()

	# Detect wall
	if not wall_waiting and is_on_wall() and not is_on_floor():
		var normal = get_wall_normal()

		if normal.x * direction < -0.5:
			wall_waiting = true
			wall_direction = int(sign(normal.x))
