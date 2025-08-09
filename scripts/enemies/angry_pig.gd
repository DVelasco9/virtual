extends CharacterBody2D

const SPEED = 300
const ray_floor = 10 
const ray_right = 9
const ray_left = -9

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready() -> void:
	velocity.x = SPEED
	$RayCast_floor.position.x = ray_floor
	$raycast_right.target_position.x = ray_right
	$raycast_left.target_position.x = ray_left


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	if not$RayCast_floor.is_colliding() or $raycast_left.is_colliding() or $raycast_right.is_colliding():
		velocity.x *= -1
		$RayCast_floor.position.x *= -1
		$raycast_left.target_position.x *= 1
		$raycast_right.target_position.x *= -1
	if velocity.x < 0:
		$AnimatedSprite2D.flip_h = false
	elif velocity.x > 0:
		$AnimatedSprite2D.flip_h = true
	
	move_and_slide()
