extends Node

signal score_updated(score_value)
signal health_updated(health)
signal lose_game()

var health = 5
var spawnRate = 1.2
var timeSinceLastSpawn = 0.0
var scoreVal = 0

var asteroidScenes = [
	preload("res://Scene/big_asteroid.tscn"),
	preload("res://Scene/medium_asteroid.tscn"),
	preload("res://Scene/small_asteroid.tscn")
]




func _ready() -> void:
	randomize()
	scoreVal=0

func _process(delta: float) -> void:
	timeSinceLastSpawn += delta
	if timeSinceLastSpawn >= spawnRate:
		spawnAsteroid()
		timeSinceLastSpawn = 0.0

func add_score(score):
	scoreVal+= score
	score_updated.emit(scoreVal)
	
func update_health(health):
	health_updated.emit(health)

func lose():
	scoreVal = 0
	lose_game.emit()

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
