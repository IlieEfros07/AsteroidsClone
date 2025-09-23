extends Area2D
var SPEED = 200
var rotaion = 0.5
var helth = 1
var direction = Vector2.ZERO
var scoreVal = 100
var rotationSpeed = 0.0

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
	helth -= damage
	modulate = Color.BLACK
	await get_tree().create_timer(0.1).timeout
	modulate = Color.WHITE
	if helth <= 0 :
		die()
func die():
	if GameManager:
		GameManager.add_score(scoreVal)
	queue_free()
	

func _on_area_entered(area):
	if area.is_in_group("bullet"):
		take_damage(area.damage)
		var knockbackDirection = (global_position - area.global_position).normalized()
		position += knockbackDirection * 10
func _on_body_entered(body):
	if body.is_in_group("player"):
		if body.has_method("take_damage"):
			body.take_damage(1)
	
