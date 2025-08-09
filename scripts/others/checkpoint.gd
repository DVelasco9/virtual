extends Area2D

@onready var nem = $Sprite2D

func _ready() -> void:
	nem.play("idle")


func _on_body_entered(body):
	if body.is_in_group("player"):
		GameData.save_checkpoint(body.global_position, body.fruitcount)
		print("Checkpoint guardado en: ", GameData.checkpoint_position, " con score: ", GameData.score)
		nem.play("touch")
		await nem.animation_finished
		nem.play("idle_flag")
		
