extends Area2D
var SPEED = 100
var rotaion = 0.5
var health = 3
var direction = Vector2.ZERO
var scoreVal=300
var rotationSpeed = 0.0
@onready var explode: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var hit: AudioStreamPlayer2D = $hit

const MEDIUM_ASTEROID = preload("res://Scene/medium_asteroid.tscn")
@onready var screenSize = get_viewport_rect().size

func _ready() -> void:
	
	direction = Vector2(randf()* 2 - 1 , randf() * 2 - 1).normalized()
	rotationSpeed = randf_range(-1.5,1.5)
	
	area_entered.connect(_on_area_entered)
	body_entered.connect(_on_body_entered)


func _process(delta: float) -> void:
	position += direction * SPEED * delta
	rotation += rotationSpeed * delta
	
	var cam = get_viewport().get_camera_2d()
	if cam:
		var cam_pos = cam.global_position
		var half_size = screenSize / 2
		position.x = wrapf(position.x, cam_pos.x - half_size.x, cam_pos.x + half_size.x)
		position.y = wrapf(position.y, cam_pos.y - half_size.y, cam_pos.y + half_size.y)
	


func take_damage(damage : int):
	health -= damage
	modulate = Color.BLACK
	if health > 0:
		hit.play()
	await get_tree().create_timer(0.1).timeout
	modulate = Color.WHITE
	if health <= 0 :
		die()
func die():
	
	var sfx = explode.duplicate()
	get_tree().current_scene.add_child(sfx)
	sfx.global_position = global_position
	sfx.play()
	
	if GameManager:
		GameManager.add_score(scoreVal)
	queue_free()

	for i in range(2):
		var new_asteroid = MEDIUM_ASTEROID.instantiate()
		new_asteroid.position = position 
		get_parent().add_child(new_asteroid)

func _on_area_entered(area):
	if area.is_in_group("bullet"):
		take_damage(area.damage)
		var knockbackDirection = (global_position - area.global_position).normalized()
		position += knockbackDirection * 10
func _on_body_entered(body):
	if body.is_in_group("player"):
		if body.has_method("take_damage"):
			body.take_damage(1)
	
