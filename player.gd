extends CharacterBody2D

@export var speed := 200.0
@export var jump_velocity := -400.0
@export var gravity := 900.0
@export var coyote_time := 0.1
@export var jump_buffer_time := 0.1

var coyote_timer := 0.0
var jump_buffer_timer := 0.0

func _physics_process(delta):
	# Gravity
	if not is_on_floor():
		velocity.y += gravity * delta
		coyote_timer -= delta
	else:
		coyote_timer = coyote_time

	# Horizontal movement
	var direction = Input.get_axis("ui_left", "ui_right")
	velocity.x = direction * speed

	# Jump buffer
	if Input.is_action_just_pressed("ui_accept"):
		jump_buffer_timer = jump_buffer_time
	else:
		jump_buffer_timer -= delta

	if jump_buffer_timer > 0 and coyote_timer > 0:
		velocity.y = jump_velocity
		jump_buffer_timer = 0

	# Move (Godot 4 version)
	move_and_slide()
