extends Node2D

var lista = []
var level2 = "res://scenes/niveles/nivel_2.tscn"

func _process(delta: float) -> void:
	lista = get_children()
	if lista.size() == 0:
		get_tree().change_scene_to_file(level2)
