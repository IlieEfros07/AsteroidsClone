extends Node

var spawnRate = 1.2
var timeSinceLastSpawn = 0.0

var asteroidScenes = [
	preload("res://Scene/big_asteroid.tscn"),
	preload("res://Scene/medium_asteroid.tscn"),
	preload("res://Scene/small_asteroid.tscn")
]

func _ready() -> void:
	randomize()

func _process(delta: float) -> void:
	timeSinceLastSpawn += delta
	if timeSinceLastSpawn >= spawnRate:
		spawnAsteroid()
		timeSinceLastSpawn = 0.0

func spawnAsteroid():
	var selectedAsteroid = asteroidScenes.pick_random()
	var asteroid = selectedAsteroid.instantiate()
	get_tree().current_scene.add_child(asteroid)

	var viewportSize = get_viewport().size
	var margin = 50
	var edge = randi() % 4

	match edge:
		0: asteroid.global_position = Vector2(randf_range(margin, viewportSize.x - margin), -margin)
		1: asteroid.global_position = Vector2(randf_range(margin, viewportSize.x - margin), viewportSize.y + margin)
		2: asteroid.global_position = Vector2(-margin, randf_range(margin, viewportSize.y - margin))
		3: asteroid.global_position = Vector2(viewportSize.x + margin, randf_range(margin, viewportSize.y - margin))
