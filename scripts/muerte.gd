extends Control


func _on_retry_pressed() -> void:
	pass
	#get_tree().reload_current_scene()

func _on_back_to_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu.tscn")

func _on_game_over_pressed() -> void:
	pass
	#get_tree().change_scene_to_file("res://scenes/EE.tscn")


func _on_checkpoint_2_pressed() -> void:
	pass # Replace with function body.
