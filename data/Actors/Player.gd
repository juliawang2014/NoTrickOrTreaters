extends "res://data/Actors/Actor.gd"


func control(delta):
	Globals.player_pos = global_position
	dir = 0
	var is_jump_interrupted
	if Globals.firing_gun:
		moving = true
		moving_switch = 0
		$AnimationPlayer.play("walking")
	else:
		moving = false
	if not moving and moving_switch == 0:
		moving_switch += 1
		$IdleTimer.start()
	if is_jumping_forever:
		jump(false)
	if Input.is_action_pressed("left"):
		dir -= 1
		$AnimationPlayer.play("walking")
	if Input.is_action_pressed("right"):
		dir += 1
		$AnimationPlayer.play("walking")
	if Input.is_action_just_pressed("up"):
		if ((is_on_floor() or in_water) or !$Timer.is_stopped()):
			$Timer.stop()
			is_jump_interrupted = false
			jumping = true
			jump(is_jump_interrupted)
		else:
			$JumpBuffer.start()
	if Input.is_action_just_released("up"):
		is_jump_interrupted = true
		jump(is_jump_interrupted)
	if !is_on_floor():
		falling = true
	if jumping and is_on_floor():
#		jumping = false
		falling = false
	if in_water:
		compute_movement(in_water_scale, in_water_gravity_scale)
	else:
		compute_movement(default_time_scale, default_time_scale)



func _on_Gun_on_left_side():
	$Sprite.flip_h = true


func _on_Gun_on_right_side():
	$Sprite.flip_h = false


func _on_IdleTimer_timeout():
	$AnimationPlayer.play("idle")
