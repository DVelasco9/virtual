extends Area2D

@export var hurt: int



func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.take_damage(hurt, global_position)
