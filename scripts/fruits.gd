extends Area2D
@onready var nim = $AnimatedSprite2D

func _ready() -> void:
	nim.play("apple")

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		nim.play("collected")
		await nim.animation_finished
		queue_free()
