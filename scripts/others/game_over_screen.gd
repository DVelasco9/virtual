extends CanvasLayer

func _on_menu_pressed():
	GameData.reset()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/menu.tscn")


func _on_reintentar_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
