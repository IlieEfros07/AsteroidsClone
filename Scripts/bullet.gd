extends Area2D
const SPEED = 600

var damage = 1
var maxDistance = 1500.0
var distanceTraveld = 0.0


@onready var sprite_2d: Sprite2D = $Sprite2D


func _ready() -> void:
	add_to_group("bullet")
	area_entered.connect(_on_area_entered)
	body_entered.connect(_on_body_entered)

func _physics_process(delta: float):
	var movement = Vector2.RIGHT.rotated(rotation) * SPEED * delta
	position += movement
	distanceTraveld += movement.length()
	if distanceTraveld >= maxDistance:
		queue_free()

func _on_area_entered(area):
	if area.is_in_group("asteroids"):
		if area.has_method("take_damage"):
			area.take_damage(damage)

func _on_body_entered(body):
	if body.is_in_group("asteroids"):
		if body.has_method("take_damage"):
			body.take_damage(damage)
		
	
	
	
