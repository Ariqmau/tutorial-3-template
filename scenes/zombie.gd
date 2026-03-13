extends CharacterBody2D

@export var gravity = 500.0
@export var walk_speed = 150.0
@export var jump_speed = -400.0

var direction = -1

@onready var anim = $AnimatedSprite2D
@onready var ledge_check = $LedgeCheck

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += delta * gravity

	if is_on_wall():
		direction *= -1

	if is_on_floor() and not ledge_check.is_colliding():
		velocity.y = jump_speed

	velocity.x = direction * walk_speed

	if direction == 1:
		anim.flip_h = false
		ledge_check.position.x = abs(ledge_check.position.x)
	else:
		anim.flip_h = true
		ledge_check.position.x = -abs(ledge_check.position.x)

	if is_on_floor():
		if velocity.x != 0:
			anim.play("walk")
		else:
			anim.play("idle")
	else:
		if velocity.y < 0:
			anim.play("jump")
		else:
			anim.play("fall")

	move_and_slide()

func _on_hitbox_body_entered(body):
	if body.name == "Player":
		if body.has_method("take_damage"):
			body.take_damage()
