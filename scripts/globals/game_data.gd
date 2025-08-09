extends Node

var checkpoint_position: Vector2 = Vector2.ZERO
var score: int = 0

func save_checkpoint(position: Vector2, player_score: int):
	checkpoint_position = position
	score = player_score

func reset():
	checkpoint_position = Vector2.ZERO
	score = 0
