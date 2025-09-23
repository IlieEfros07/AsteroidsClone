extends Area2D

const SPEED = 600
const MAX_DISTANCE = 1500.0
var distanceTravelled = 0.0
var damage = 1

func _ready() -> void:
	add_to_group("bullet")
	area_entered.connect(_on_area_entered)
	body_entered.connect(_on_body_entered)

func _physics_process(delta: float):
	var movement = Vector2.RIGHT.rotated(rotation) * SPEED * delta
	position += movement
	distanceTravelled += movement.length()
	if distanceTravelled >= MAX_DISTANCE:
		queue_free()

func _on_area_entered(area):
	if area.is_in_group("asteroids") and area.has_method("take_damage"):
		area.take_damage(damage)

func _on_body_entered(body):
	if body.is_in_group("asteroids") and body.has_method("take_damage"):
		body.take_damage(damage)
