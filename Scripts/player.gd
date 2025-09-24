extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const BULLET = preload("res://Scene/bullet.tscn")
const FIRE_RATE = 0.2
@onready var shoot: AudioStreamPlayer2D = $Shoot


@onready var screenSize = get_viewport_rect().size

@onready var animatedSprite2d: AnimatedSprite2D = $AnimatedSprite2D

var canFire= true
var fireTimer = 0.0
var health = 5
var isDead = false

func _ready() -> void:
	add_to_group("player")

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
	
	if Input.is_action_just_pressed("down") or Input.is_action_just_pressed("up") or Input.is_action_just_pressed("right") or Input.is_action_just_pressed("left"):
		animatedSprite2d.play("move")
	elif Input.is_action_pressed("down") or Input.is_action_pressed("up") or Input.is_action_pressed("right") or Input.is_action_pressed("left"):
		animatedSprite2d.play("move_more") 
	else:
		animatedSprite2d.play("idle")
	if isDead:
		velocity = Vector2.ZERO
		return
		
	
	
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
	var cam = get_viewport().get_camera_2d()
	if cam:
		var cam_pos = cam.global_position
		var half_size = screenSize / 2
		position.x = wrapf(position.x, cam_pos.x - half_size.x, cam_pos.x + half_size.x)
		position.y = wrapf(position.y, cam_pos.y - half_size.y, cam_pos.y + half_size.y)
	



func _shoot():
	canFire=false
	var bullet = BULLET.instantiate()
	bullet.position = $Muzzle.global_position
	var mouseDirection = (get_global_mouse_position() - global_position).angle()
	bullet.rotation = mouseDirection
	get_parent().add_child(bullet)
	shoot.play()

func take_damage(damage:int):
	health -= damage
	modulate = Color.BLACK
	if GameManager:
		GameManager.update_health(health)
	await get_tree().create_timer(0.1).timeout
	modulate = Color.WHITE
	if health <= 0:
		die()
func die():
	if GameManager:
		GameManager.lose()
	isDead = true
	await get_tree().create_timer(2.0).timeout
	get_tree().reload_current_scene()

	
	


	

	
