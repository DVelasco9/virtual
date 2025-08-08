@tool
extends Area2D


@export_enum("apple","banana") var fruitType : String = "apple":
	set(value):
		fruitType = value
		$AnimatedSprite2D.animation = fruitType
	

func _ready() -> void:
	if not Engine.is_editor_hint():
		$AnimatedSprite2D.play(fruitType)

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("collectfruit"):
		body.collectfruit(fruitType)
		
		
	if body.is_in_group("player"):
		$AnimatedSprite2D.play("collected")
		await $AnimatedSprite2D.animation_finished
		queue_free()
