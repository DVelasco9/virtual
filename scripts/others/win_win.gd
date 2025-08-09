extends Node2D

var lista = []
var level = "res://scenes/others/be continue.tscn"

func _process(delta: float) -> void:
	lista = get_children()
	if lista.size() == 0:
		get_tree().change_scene_to_file(level)
