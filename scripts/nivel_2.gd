extends Node2D

var jugador = preload("res://scenes/character_body_2d.tscn")

func _ready() -> void:
	var new_player = jugador.instantiate()
	new_player.position = $spawn_player.position
	add_child(new_player)
