extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const BULLET = preload("res://Scene/bullet.tscn")
const FIRE_RATE = 0.2

@onready var animatedSprite2d: AnimatedSprite2D = $AnimatedSprite2D

var canFire= true
var fireTimer = 0.0


func _physics_process(delta: float) -> void:

	animatedSprite2d.look_at(get_global_mouse_position())
	rotation_degrees += 90

	var directionY := Input.get_axis("up","down")
	if directionY:
		velocity.y = directionY * SPEED
	else:
		velocity.y = move_toward(velocity.y,0,SPEED)
	
	var directionX := Input.get_axis("left", "right")
	
	if Input.is_action_pressed("shoot") and canFire:
		_shoot()
		
	if not canFire:
		fireTimer += delta
		if fireTimer>= FIRE_RATE:
			canFire=true
			fireTimer = 0.0
	
	if directionX:
		velocity.x = directionX * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func _shoot():
	canFire=false
	var bullet = BULLET.instantiate()
	bullet.position = $Muzzle.global_position
	var mouseDirection = (get_global_mouse_position() - global_position).angle()
	bullet.rotation = mouseDirection
	get_parent().add_child(bullet)

	
