# VIRTUAL

## DESCRIPCION
Juego estilo plataformero con el objetivo de pasar niveles, evitando las trampas y recolectando la mayor cantidad de frutas posibles

## CARACTERISTICAS 
Juego 2D
Plataformero


## RECURSOS USADOS 
### PLAYER 
<img width="352" height="32" alt="Idle (32x32)" src="https://github.com/user-attachments/assets/0b84722c-f83e-4b05-8a3d-fcea83285410" />

### TILEMAP
<img width="352" height="176" alt="Terrain (16x16)" src="https://github.com/user-attachments/assets/c98a6fea-bda6-4b0d-9dc2-ce366fa1ac48" />

### TRAMPAS
<img width="304" height="38" alt="On (38x38)" src="https://github.com/user-attachments/assets/e8a10e6a-baa1-4ce3-a0e5-8304a1779c72" />

<img width="28" height="28" alt="Spiked Ball" src="https://github.com/user-attachments/assets/8f494302-23e3-46a5-8a27-745cb8ddce2f" />

### FRUITS
<img width="544" height="32" alt="Apple" src="https://github.com/user-attachments/assets/5e66ab33-f66f-47a7-b527-11454107ca19" />
<img width="544" height="32" alt="Bananas" src="https://github.com/user-attachments/assets/07a47288-7410-45a5-9ff5-634b11af89fe" />

### CHECKPOINT
<img width="640" height="64" alt="Checkpoint (Flag Idle)(64x64)" src="https://github.com/user-attachments/assets/0f7c14b4-d06c-4d72-b42c-e30bb0b4c9f0" />

### BACKGROUND
[New_BG.zip](https://github.com/user-attachments/files/21699952/New_BG.zip)


## CODIGOS PRINCIPALES
### PLAYER 
```
extends CharacterBody2D

@export var move : float
@export var jump : float 
@export var run : float 
@onready var animation = $AnimatedSprite2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


var facing_right = true
var running = false
var max_health := 100
var current_health := max_health
var is_dead := false
var is_invulnerable := false
var spawning := true
var knockback_time := 0.2  
var knockback_timer := 0.0
var fruitcount = 0

func take_damage(amount : int, from_position):
	if is_dead or is_invulnerable:
		return
	
	current_health -= amount 
	current_health = clamp(current_health, 0, max_health)
	
	is_invulnerable = true
	
	knockback(from_position)
	
	animation.play("hit")
	
	
	await get_tree().create_timer(0.3).timeout
	is_invulnerable = false
	

	
	if current_health == 0:
		die()

func knockback(from_position: Vector2):
	var direction = sign(global_position.x - from_position.x)
	velocity.x = direction * 150
	velocity.y = -200  
	knockback_timer = knockback_time

func die():
	
	if is_dead:
		return
	is_dead = true 
	
	print("el jugador ha muerto")
	
	animation.play("death")
	$CollisionShape2D.disabled = true 
	velocity = Vector2.ZERO
	
	await animation.animation_finished
	print("Animación terminada")
	
	get_tree().paused = true
	$game_over_screen.visible = true

func _ready() -> void:
	add_to_group("player")
		# Si hay un checkpoint guardado, aparecer ahí y restaurar puntos
	if GameData.checkpoint_position != Vector2.ZERO:
		global_position = GameData.checkpoint_position
		fruitcount = GameData.score
	
	respawn()

func _physics_process(delta: float) -> void:
	if is_dead:
		return
	
	if knockback_timer > 0:
		knockback_timer -= delta
		if not is_on_floor():
			velocity.y += gravity * delta
		move_and_slide()
		return
	
	if is_invulnerable and animation.animation == "hit":
		if not is_on_floor():
			velocity.y += gravity * delta
		move_and_slide()
		return
	
	move_x()
	estado()
	djump(delta)
	flip()
	update_anime()
	move_and_slide()
	

func move_x():
	var input_axis = Input.get_axis("left", "right")
	
	if running:
		velocity.x = input_axis * (move * run)
	else:
		velocity.x = input_axis * move

func estado():
	if Input.is_action_just_pressed("run"):
		running = true 
	if Input.is_action_just_released("run"):
		running = false

func djump(delta):
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump
	if not is_on_floor():
		velocity.y += gravity * delta

func flip():
	if (facing_right and velocity.x < 0) or (not facing_right and velocity.x > 0):
		scale.x *= -1
		facing_right = not facing_right

func update_anime():
	if not is_on_floor():
		if velocity.y < 0:
			animation.play("jump")
		return
	
	if running:
		animation.play("run")
	elif velocity.x != 0:
		animation.play("walk")
	else:
		animation.play("idle")

func respawn():
	spawning = true
	animation.play("spawn", 2.0)
	#$CollisionShape2D.disabled = true
	await animation.animation_finished
	spawning = false
	#$CollisionShape2D.disabled = false

func collectfruit(fruitType):
	var auxstring = fruitType + "points"
	var gainedpoints = GeneralRules[auxstring]
	fruitcount += gainedpoints
	


func _on_area_2d_body_entered(body: Node2D) -> void:
	pass # Replace with function body.

```
### FRUITS
```
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

```

### PLAYER INFO
```
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

```

### SAW
```
extends CharacterBody2D

const SPEED = 200
const ray_floor_x = 18
const ray_wall_target_position_x = 13

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready() -> void:
	velocity.x = SPEED
	$Ray_floor_detection.position.x = ray_floor_x
	$Ray_wall_detection.target_position.x = ray_wall_target_position_x


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	if not $Ray_floor_detection.is_colliding() or $Ray_wall_detection.is_colliding():
		velocity.x *= -1
		$Ray_floor_detection.position.x *= -1
		$Ray_wall_detection.target_position.x *= -1
	
	
	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	pass # Replace with function body.

```
### SPIKEBALL
```
extends Node2D

@onready var r_floor = $raycast_floor_detection

var floor_detected = false
var safe_time = false
var raycast_init_value= 36

func _ready() -> void:
	r_floor.target_position.y = raycast_init_value
	$safe_time.start()
	

func _process(delta: float) -> void:
	if not floor_detected && safe_time:
		r_floor.target_position.y += 6
		if r_floor.is_colliding():
			floor_detected = true
			r_floor.target_position.y -= 6
			init_spikeball()
		

func init_spikeball():
	var number_of_chains = (r_floor.target_position.y - raycast_init_value) / 6
	$spike.position.y += (number_of_chains * 6)
	for i in range(number_of_chains):
		var new_ring = preload("res://scenes/chain.tscn").instantiate()
		new_ring.position = Vector2(0,(6 * (i + 1) ))
		self.add_child(new_ring)
	$AnimationRotation.play("regular_move")

func _on_safe_time_timeout() -> void:
	safe_time = true


func _on_area_collision_map_body_entered(body: Node2D) -> void:
	$AnimationRotation.speed_scale *= -1

```
### DAMAGE DETECTION
```
extends Area2D

@export var hurt: int

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.take_damage(hurt, global_position)
		

```
### CHECKPOINT
```
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
		
```
### PORTAL
```
extends Node2D

var send_player_to = Vector2()

func _ready() -> void:
	add_to_group("portal")
	await get_tree().process_frame 
	find_other_portal()

func find_other_portal():
	var portals = get_tree().get_nodes_in_group("portal")
	for portal in portals:
		if portal != self:
			send_player_to = portal.global_position
			
			

func _on_area_portal_area_entered(area: Area2D) -> void:
	if area.get_parent().is_in_group("player"):
		
		if get_parent().get_node("virtual").fruitcount >= 0: 
			
			area.get_parent().position = send_player_to
		
		

```
### GAME DATA
```
extends Node

var checkpoint_position: Vector2 = Vector2.ZERO
var score: int = 0
var collected_fruits: Array = []


func save_checkpoint(position: Vector2, player_score: int):
	checkpoint_position = position
	score = player_score

func collect_fruit(fruit_id: String):
# Ignorar ids vacíos
	if fruit_id == null or fruit_id.strip_edges() == "":
		push_warning("GameData.collect_fruit llamado con id vacío; ignorando.")
		return
	if fruit_id in collected_fruits:
		return
	collected_fruits.append(fruit_id)
	print("GameData: fruta guardada -> ", fruit_id)


func reset():
	checkpoint_position = Vector2.ZERO
	score = 0
	collected_fruits.clear()

```
### GENERAL RULES 
```
extends Node

var applepoints = 1
var bananapoints = 2
var collectedpoints = 0

```
## VIDEOS

## COMENTARIO FINAL 
Fue una experiencia interesante y desafiante, la verdad no puedo decir mucho porque el anterior juego hizo que este fuera mucho más facil, sin embargo me sirvio para darme cuenta lo dificil y tedioso que es ser un programador de videojuegos, porque si le mueves a algo lo otro ya salio mal, osea, muchas veces hay que modificar una y otra vez codigos que segun tu ya estaban bien hechos y funcionales

PD: GODOT me va a provocar una psicocirugía

## COMPRIMIDO DEL JUEGO
[virtual_finished.zip](https://github.com/user-attachments/files/21699985/virtual_finished.zip)

