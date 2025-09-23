extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.score_updated.connect(_on_score_updated)
	GameManager.health_updated.connect(_on_health_updated)
	GameManager.lose_game.connect(_on_game_lose)

var score = 0

func _on_score_updated(scoreValue):
	var scoreLabel = get_node_or_null("Labels/Score")
	score = scoreValue
	if scoreLabel:
		scoreLabel.text = "Score: " + str(scoreValue)
	else:
		print("ScoreLabel not found!")
func _on_health_updated(health):
	var healthLabel = get_node_or_null("Labels/Health")
	if healthLabel:
		healthLabel.text = "Health: " + str(health)


func _on_game_lose():
	var loseLabel = get_node_or_null("Labels/Lose")
	if loseLabel:
		loseLabel.text = " You lose ! \nHigh Score: "+ str(score)
		loseLabel.visible = true

		
