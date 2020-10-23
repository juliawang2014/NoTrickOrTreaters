extends "res://data/Actors/Actor.gd"

var effect

func _ready():
	randomize()
	effect = AudioServer.get_bus_effect(3,0)

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
		if can_footstep and is_on_floor():
			can_footstep = false
#			$SoundTimer.start()
			effect.pitch_scale = randf() * 1.0 + 0.5
			$Footsteps.play()
		$AnimationPlayer.play("walking")
	if Input.is_action_pressed("right"):
		dir += 1
		if can_footstep and is_on_floor():
			can_footstep = false
#			$SoundTimer.start()
			effect.pitch_scale = randf() * 1.0 + 0.5
			$Footsteps.play()
		$AnimationPlayer.play("walking")
	if Input.is_action_just_pressed("up"):
		if ((is_on_floor() or in_water) or !$Timer.is_stopped()):
			$Timer.stop()
			is_jump_interrupted = false
			jumping = true
			$JumpSounds.play()
			jump(is_jump_interrupted)
		else:
			$JumpBuffer.start()
	if Input.is_action_just_released("up"):
		is_jump_interrupted = true
		jump(is_jump_interrupted)
	if !is_on_floor():
		falling = true
	if falling and is_on_floor():
		falling = false
		$LandSounds.play()
	if jumping and is_on_floor():
#		jumping = false
#		falling = false
		pass
	if in_water:
		compute_movement(in_water_scale, in_water_gravity_scale)
	else:
		compute_movement(default_time_scale, default_time_scale)

func play_footstep():
	$Footsteps.play()

func _on_Gun_on_left_side():
	$Sprite.flip_h = true


func _on_Gun_on_right_side():
	$Sprite.flip_h = false


func _on_IdleTimer_timeout():
	$AnimationPlayer.play("idle")


func _on_SoundTimer_timeout():
	can_footstep = true


func _on_StopChild_body_entered(body):
	if Globals.current_level != Globals.dream_planet:
		if body.name == "AlienChild" or body.name == "EyeChild" or body.name == "CandyCornChild":
			body.state = 0
