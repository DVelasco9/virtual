extends CharacterBody2D

@export var move : float
@export var jump : float 
@export var run : float 
@onready var animation = $AnimatedSprite2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var facing_right = true
var running = false
var max_health := 3
var current_health := max_health
var is_dead := false
var is_invulnerable := false
var spawning := true
var knockback_time := 0.2  
var knockback_timer := 0.0
var last_checkpoint_position: Vector2


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
	
	get_tree().change_scene_to_file("res://scenes/muerte.tscn")





func _ready() -> void:
	add_to_group("player")
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



func _on_area_2d_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
