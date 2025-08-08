extends CanvasLayer

@onready var menupopup : Node2D = $menuPopup




func _ready() -> void:
	menupopup.visible = false
	$fruitpoints.text = "puntuación: " + str(get_parent().fruitcount)
	$healthbar.value = get_parent().current_health
	
func _process(delta: float) -> void:
	$healthbar.value = get_parent().current_health
	$fruitpoints.text = "puntuación: " + str(get_parent().fruitcount)
	var current_time = Time.get_datetime_dict_from_system()
	if current_time.minute < 10:
		$clock.text = str(current_time.hour) + ":0" + str(current_time.minute)
	else:
		$clock.text = str(current_time.hour) + ":" + str(current_time.minute)


#### MENU DE PAUSA ####
func _on_menu_button_pressed() -> void:
	get_tree().paused = true
	menupopup.visible = get_tree().paused

func _on_continue_pressed() -> void:
	get_tree().paused = false
	menupopup.visible = get_tree().paused


func _on_restart_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
	

func _on_backmenu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/menu.tscn")

func _on_exit_pressed() -> void:
	get_tree().quit()
