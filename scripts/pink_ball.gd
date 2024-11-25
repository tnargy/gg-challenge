class_name PinkBall
extends TankAndBall

func _physics_process(delta):
	if stuck: return
	current_direction = raycast.target_position / size
	if not raycast.is_colliding():
		speed_delta -= delta
		if speed_delta <= 0:
			speed_delta = speed
			position += current_direction * 2 * size
	else:
		move()
