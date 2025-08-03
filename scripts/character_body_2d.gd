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


func _ready() -> void:
	add_to_group("player")

func _physics_process(delta: float) -> void:
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
	if Input.is_action_just_pressed("jump"):
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
