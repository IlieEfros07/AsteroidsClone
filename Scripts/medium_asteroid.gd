extends Area2D
var SPEED = 150
var rotaion = 0.5
var helth = 3
var direction = Vector2.ZERO
const SMALL_ASTEROID = preload("res://Scene/small_asteroid.tscn")

func _ready() -> void:
	
	direction = Vector2(randf()* 2 - 1 , randf() * 2 - 1).normalized()
	rotation = randf_range(-2.0,2.0)
	
	area_entered.connect(_on_area_entered)
	body_entered.connect(_on_body_entered)


func _process(delta: float) -> void:
	position += direction * SPEED * delta
	
	rotation += rotation * delta
	
	var screenSize = get_viewport_rect().size
	
	if position.x < 0: position.x = screenSize.x
	if position.x > screenSize.x: position.x = 0
	if position.y < 0: position.y = screenSize.y
	if position.y > screenSize.y: position.y = 0
	


func take_damage(damage : int):
	helth -= damage
	modulate = Color.BLACK
	await get_tree().create_timer(0.1).timeout
	modulate = Color.WHITE
	if helth <= 0 :
		die()
func die():
	queue_free()
	for i in range(2):
		var new_asteroid = SMALL_ASTEROID.instantiate()
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
	
