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
