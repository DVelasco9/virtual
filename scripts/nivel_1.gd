extends Node2D

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("pausa"):
		get_tree().change_scene_to_file("res://scenes/pausa.tscn")
