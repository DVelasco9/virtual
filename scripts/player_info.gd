extends CanvasLayer

@onready var menupopup : Node2D = $menuPopup




func _ready() -> void:
	menupopup.visible = false
	$healthbar.value = get_parent().current_health
	
func _process(delta: float) -> void:
	$healthbar.value = get_parent().current_health

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
