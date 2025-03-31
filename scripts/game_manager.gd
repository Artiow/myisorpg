extends Node


@onready var score_label: Label = $ScoreLabel


var player_score = 0


func _ready() -> void:
	update_label()


func add_player_score_point() -> void:
	player_score += 1
	update_label()


func update_label() -> void:
	score_label.text = "Well done! You collected %s coins!" % player_score
