extends CharacterBody2D

@export var gravity = 500.0
@export var walk_speed = 200.0
@export var jump_speed = -300.0
@export var dash_speed = 600.0
@export var crouch_speed = 100.0
@export var wall_jump_push = 300.0

var max_jumps = 2
var jumps_left = 2
var is_dashing = false
var dash_time = 0.2
var dash_timer = 0.0
var last_input_dir = 0
var tap_timer = 0.0
var double_tap_window = 0.3
var is_crouching = false

@onready var collision_standing = $CollisionStanding
@onready var collision_crouching = $CollisionCrouching
@onready var anim = $AnimatedSprite2D


func _physics_process(delta):
	if not is_on_floor():
		velocity.y += delta * gravity
	else:
		jumps_left = max_jumps

	if is_on_wall() and Input.is_action_just_pressed("ui_up"):
		var wall_normal = get_wall_normal()
		velocity.x = wall_normal.x * wall_jump_push
		velocity.y = jump_speed
		jumps_left = max_jumps - 1

	if Input.is_action_just_pressed("ui_up") and jumps_left > 0:
		velocity.y = jump_speed
		jumps_left -= 1

	tap_timer -= delta
	if dash_timer > 0:
		dash_timer -= delta
		move_and_slide()
		return
	else:
		is_dashing = false

	if Input.is_action_pressed("ui_down"):
		if is_on_floor() or is_crouching:
			is_crouching = true
	else:
		is_crouching = false

	if is_crouching:
		collision_standing.disabled = true
		collision_crouching.disabled = false
	else:
		collision_standing.disabled = false
		collision_crouching.disabled = true

	var current_speed = walk_speed
	if is_crouching:
		current_speed = crouch_speed

	var dir = 0
	if Input.is_action_just_pressed("ui_left"):
		if last_input_dir == -1 and tap_timer > 0:
			is_dashing = true
			dash_timer = dash_time
			velocity.x = -dash_speed
		else:
			last_input_dir = -1
			tap_timer = double_tap_window
	elif Input.is_action_just_pressed("ui_right"):
		if last_input_dir == 1 and tap_timer > 0:
			is_dashing = true
			dash_timer = dash_time
			velocity.x = dash_speed
		else:
			last_input_dir = 1
			tap_timer = double_tap_window

	if not is_dashing:
		if Input.is_action_pressed("ui_left"):
			velocity.x = -current_speed
			dir = -1
			anim.flip_h = true
		elif Input.is_action_pressed("ui_right"):
			velocity.x = current_speed
			dir = 1
			anim.flip_h = false
		else:
			velocity.x = 0

	if is_on_floor():
		if is_crouching:
			anim.play("crouch")
		elif dir != 0:
			anim.play("walk")
		else:
			anim.play("idle")
	else:
		if velocity.y < 0:
			anim.play("jump")
		else:
			anim.play("fall")

	move_and_slide()
