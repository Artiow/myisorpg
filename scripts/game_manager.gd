class_name GameManager
extends Node

@onready var _score_label: Label = $ScoreLabel
@onready var _score_label_format := _score_label.text

var _player_score := 0


func _ready():
	_update_label()


func add_player_score(points: int = 1):
	_player_score += points
	_update_label()
	print_debug(self, ": points added = %.f, total = %.f" % [points, _player_score])


func _update_label():
	_score_label.text = _score_label_format % _player_score
