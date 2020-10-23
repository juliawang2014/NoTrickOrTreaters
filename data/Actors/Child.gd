extends "res://data/Actors/Actor.gd"

export (float) var detect_radius
export (float) var follow_radius
var run_away = false
var run_to_right = false
var switch = 0
var player_present = false
enum STATES {idle, walking, running}
var state = STATES.idle
var hovering = false
var can_be_caught = false
var caught = false
var times_caught = 0
var can_idle = true
var effect
signal captured

func _ready():
	var circle = CircleShape2D.new()
	$DetectPlayer/CollisionShape2D.shape = circle
	if Globals.current_level == Globals.dream_planet:
		$DetectPlayer/CollisionShape2D.shape.radius = detect_radius
		var circle2 = CircleShape2D.new()
		$CaptureArea/CollisionShape2D.shape = circle2
		$CaptureArea/CollisionShape2D.shape.radius = 30
	else:
		$DetectPlayer/CollisionShape2D.shape.radius = follow_radius
	effect = AudioServer.get_bus_effect(4,0)

func _input(event):
	if event.is_action_pressed("click") and hovering and !Globals.dragging_something:
		being_dragged = true
		Globals.dragging_something = true
	elif event.is_action_released("click"):
		being_dragged = false
		Globals.dragging_something = false
	if event.is_action_pressed("interact") and can_be_caught:
		caught = true
		times_caught += 1
		get_teleported()
		emit_signal("captured", times_caught)
		

func get_teleported():
	$Tween.interpolate_property(self, "modulate", modulate, Color(10,10,10,10), 
		1.5,Tween.TRANS_CUBIC,Tween.EASE_IN)
	$Tween.interpolate_property(self, "scale", scale, Vector2(0,1), 
		1.5, Tween.TRANS_CUBIC, Tween.EASE_IN)
	$Tween.start()
	$TeleportNoise.play()

func check_block_movement():
	var target = $RayCast2D.get_collider()
	if target and Globals.stay and Globals.current_level != Globals.dream_planet:
		if target is KinematicBody2D:
			$PinJoint2D.node_b = "root/Blocks/%s" % target.name
	else:
		$PinJoint2D.node_b = ""

func control(delta):
	dir = 0
	if (Globals.stay and Globals.current_level != Globals.dream_planet) or being_dragged:
		state = STATES.idle
	elif Globals.follow and !player_present and Globals.current_level != Globals.dream_planet:
		state = STATES.walking
	check_block_movement()
	match state:
		STATES.running:
			if run_away:
				if run_to_right:
					dir += 1
					if direction == 1:
						$Sprite.flip_h = true
					else:
						$Sprite.flip_h = false
				else:
					dir -= 1
					if direction == 1:
						$Sprite.flip_h = false
					else:
						$Sprite.flip_h = true
				play_animation("moving", 2)
		STATES.walking:
			play_animation("moving")
			if Globals.player_pos.x < global_position.x:
				dir -= 0.5
				$Sprite.flip_h = false
			elif Globals.player_pos.x > global_position.x:
				dir += 0.5
				$Sprite.flip_h = true
#			elif Globals.player_pos.x == global_position.x:
#				state = STATES.idle
		STATES.idle:
			play_animation("idle")
#			if being_dragged:
#				position = get_global_mouse_position()
#				return
	if (is_on_wall() and is_on_floor()) or (was_on_floor and !is_on_floor()) or is_jumping_forever:
		jump(false)
	if was_on_floor and !is_on_floor():
		$JumpSounds.play()
	if is_on_wall() and state == STATES.running:
		direction *= -1
	if !is_on_wall():
		falling = true
	if falling and is_on_wall():
		$LandSounds.play()
	if in_water:
		compute_movement(in_water_scale, in_water_gravity_scale)
	else:
		compute_movement(default_time_scale, default_time_scale)

func play_footstep():
#	$Footsteps.play()
	pass

func play_animation(new_state, anim_speed = 1):
#	if switch == 0:
#		switch += 1
	match new_state:
		"moving":
			if can_footstep and is_on_floor():
				can_footstep = false
#				$FootstepTimer.start()
				effect.pitch_scale = randf() * 1.0 + 2.5
#				if anim_speed == 2:
##					$Footsteps.pitch_scale = anim_speed
#					effect.pitch_scale = 1.0/anim_speed
				$Footsteps.play()
		"idle":
			pass
	$AnimationPlayer.playback_speed = anim_speed
	$AnimationPlayer.play(new_state)

func _on_DetectPlayer_body_entered(body):
	if body.name == "Player" and (Globals.current_level == Globals.dream_planet) and not caught:
#		switch = 0
		state = STATES.running
		run_away = true
		if body.global_position.x < global_position.x:
			run_to_right = true
		else:
			run_to_right = false
	elif body.name == "Player" and (Globals.current_level != Globals.dream_planet):
#		switch = 0
		state = STATES.idle
	player_present = true

func _on_DetectPlayer_body_exited(body):
	if body.name == "Player" and (Globals.current_level == Globals.dream_planet) and not caught:
#		switch = 0
		state = STATES.idle
		run_away = false
	elif body.name == "Player" and (Globals.current_level != Globals.dream_planet):
#		switch = 0
		state = STATES.walking
	player_present = false

func play_idle_sounds():
	if can_idle:
		can_idle = false
		$SoundTimer.start()
		$IdleSounds.play()

func _on_HoverArea_mouse_entered():
	hovering = true


func _on_HoverArea_mouse_exited():
	hovering = false


func _on_CaptureArea_body_entered(body):
	if body.name == "Player":
		can_be_caught = true


func _on_CaptureArea_body_exited(body):
	if body.name == "Player":
		can_be_caught = false


func _on_Tween_tween_completed(object, key):
	call_deferred('free')


func _on_SoundTimer_timeout():
	can_idle = true


func _on_FootstepTimer_timeout():
	can_footstep = true
