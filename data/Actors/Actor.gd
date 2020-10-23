extends KinematicBody2D

export var speed = 500
export var acceleration = 0.5
export var friction = 0.05
export (float) var gravity = 20
export var jumpForce = 200
var velocity = Vector2()
var in_water = false
export (float) var in_water_scale = 0.5
export (float) var in_water_gravity_scale = 0.2
var default_time_scale = 1.0
var direction = 1
var dir = 0

var jump_interruption_counter = 0
var jumping = false
var falling = false
var moving = false
var moving_switch = 0
var was_on_floor
var being_dragged = false
var snap
var is_jumping_forever = false

var can_footstep = true
#var effect

func _physics_process(delta):
	snap = Vector2.DOWN * 32
	control(delta)
	was_on_floor = is_on_floor()
	velocity = move_and_slide(velocity, Vector2.UP, true)
#	velocity = move_and_slide_with_snap(velocity, snap, Vector2.UP, true)
	if !is_on_floor() and was_on_floor and not jumping:
		$Timer.start()
	if is_on_floor() and !$JumpBuffer.is_stopped():
		$JumpBuffer.stop()
		jump(false)

func _input(event):
	if event.is_action_pressed("left") or event.is_action_pressed("right") or event.is_action_pressed("up"):
		moving = true
		moving_switch = 0
	elif event.is_action_released("left") or event.is_action_released("right") or event.is_action_released("up"):
		moving = false

func control(delta):
	pass

func compute_movement(time_scale, gravity_ts):
	if dir != 0:
		velocity.x = lerp(velocity.x, dir * speed * time_scale * direction, acceleration)
	else:
		velocity.x = lerp(velocity.x, 0, friction)
	if being_dragged:
		velocity.y = 0.0
	else:
		velocity.y += (gravity * gravity_ts)

func jump_forever(do):
	is_jumping_forever = true if do else false

func jump(is_jump_interrupted):
	snap = Vector2.ZERO
	if is_jump_interrupted and jumping:
		jumping = false
		velocity.y = 0.0
	elif !is_jump_interrupted:
		jumping = true
		velocity.y = -jumpForce
