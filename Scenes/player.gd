
extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -400.0
const WALL_JUMP_TIME = 0.2

var direction = 1

var wall_timer = 0.0
var wall_waiting = false
var wall_direction = 0


func _physics_process(delta: float) -> void:
	# Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	if wall_waiting:
		velocity.x = 0

		# Jump during the 0.2-second window
		if Input.is_action_just_pressed("jump"):
			velocity.y = JUMP_VELOCITY
			direction = wall_direction
			wall_waiting = false
			velocity.x = SPEED * direction

		else:
			wall_timer -= delta

			# Time expired: bounce backward
			if wall_timer <= 0:
				direction = wall_direction
				wall_waiting = false
				velocity.x = SPEED * direction

	else:
		# Normal jump
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		velocity.x = SPEED * direction

	move_and_slide()

	# Detect new wall collision
	if not wall_waiting and is_on_wall():
		var normal = get_wall_normal()

		if normal.x * direction < -0.5:
			wall_waiting = true
			wall_timer = WALL_JUMP_TIME
			wall_direction = int(sign(normal.x))
