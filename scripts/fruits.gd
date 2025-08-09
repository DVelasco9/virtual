@tool
extends Area2D


@export_enum("apple","banana","collected") var fruitType : String = "apple":
	set(value):
		fruitType = value
		$AnimatedSprite2D.animation = fruitType
	
@export var fruit_id: String = ""  # ID único para esta fruta

func _ready() -> void:
	# Si no le pusiste id en el inspector, usa el nombre del nodo como fallback
	if fruit_id == null or fruit_id.strip_edges() == "":
		fruit_id = name
	
	if not Engine.is_editor_hint():
		# debug: muestra la lista al cargar la escena
		print("GameData.collected_fruits = ", GameData.collected_fruits)
		# Si ya fue recogida, eliminarla
		if fruit_id in GameData.collected_fruits:
			print("Fruta ya recogida, eliminando -> ", fruit_id)
			queue_free()
			return
		$AnimatedSprite2D.play(fruitType)

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("collectfruit"):
		body.collectfruit(fruitType)
		
		
	if body.is_in_group("player"):
		GameData.collect_fruit(fruit_id)
		$AnimatedSprite2D.play("collected")
		await $AnimatedSprite2D.animation_finished
		queue_free()
