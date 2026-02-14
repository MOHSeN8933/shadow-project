extends CharacterBody2D

@export var speed := 500.0
@export var jump_velocity := -700.0
@export var gravity := 1900.0
@export var coyote_time := 1
@export var jump_buffer_time := 1

@export var dash_speed := 600.0
@export var dash_time := 0.15
@export var dash_cooldown := 0.4

@export var acceleration := 1200.0
@export var friction := 1500.0

var is_dashing := false
var dash_timer := 0.0
var dash_cooldown_timer := 0.0

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
	if direction != 0:
		velocity.x = move_toward(velocity.x, direction * speed, acceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, friction * delta)

	# Jump buffer
	if Input.is_action_just_pressed("ui_accept"):
		jump_buffer_timer = jump_buffer_time
	else:
		jump_buffer_timer -= delta

	if jump_buffer_timer > 0 and coyote_timer > 0:
		velocity.y = jump_velocity
		jump_buffer_timer = 0
	
	# Dash Cooldown
	if dash_cooldown_timer > 0:
		dash_cooldown_timer -= delta

	# Dash Start
	if Input.is_action_just_pressed("dash") and dash_cooldown_timer <= 0:
		is_dashing = true
		dash_timer = dash_time
		dash_cooldown_timer = dash_cooldown
	
	if is_dashing:
		dash_timer -= delta
		velocity.y = 0
		velocity.x = sign(velocity.x) * dash_speed
	
	if dash_timer <= 0:
		is_dashing = false

	# Move (Godot 4 version)
	move_and_slide()
