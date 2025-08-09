extends Node

var checkpoint_position: Vector2 = Vector2.ZERO
var score: int = 0
var collected_fruits: Array = []


func save_checkpoint(position: Vector2, player_score: int):
	checkpoint_position = position
	score = player_score

func collect_fruit(fruit_id: String):
# Ignorar ids vacíos
	if fruit_id == null or fruit_id.strip_edges() == "":
		push_warning("GameData.collect_fruit llamado con id vacío; ignorando.")
		return
	if fruit_id in collected_fruits:
		return
	collected_fruits.append(fruit_id)
	print("GameData: fruta guardada -> ", fruit_id)


func reset():
	checkpoint_position = Vector2.ZERO
	score = 0
	collected_fruits.clear()
