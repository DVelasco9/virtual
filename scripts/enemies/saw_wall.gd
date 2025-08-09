extends CharacterBody2D

const SPEED = 200
const RAY_WALL_2 = -14
const ray_floor_x = 18
const ray_wall_target_position_x = 13

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready() -> void:
	velocity.x = SPEED
	$ray_wall_detection_2.target_position.x = RAY_WALL_2
	$Ray_floor_detection.position.x = ray_floor_x
	$Ray_wall_detection.target_position.x = ray_wall_target_position_x


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	if not $Ray_floor_detection.is_colliding() or $Ray_wall_detection.is_colliding() or $ray_wall_detection_2.is_colliding():
		velocity.x *= -1
		$Ray_floor_detection.position.x *= -1
		$Ray_wall_detection.target_position.x *= -1
		$ray_wall_detection_2.target_position.x *= 1
	
	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
