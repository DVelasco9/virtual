extends Control


func _on_retry_pressed() -> void:
	pass



func _on_back_to_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
