extends KinematicBody2D

var hovering = true
export var gravity = 25
var new_texture
var velocity = Vector2()
var being_dragged = true
var in_water = false
var falling = false
var stopped = false

func _ready():
	set_texture()
	var square = RectangleShape2D.new()
	$CollisionShape2D.shape = square
	$CollisionShape2D.shape.extents = Vector2(16,16)
	$Area2D/CollisionShape2D.shape = square
	$Area2D/CollisionShape2D.shape.extents = Vector2(16,16)
	position = get_global_mouse_position()

func _input(event):
	if event.is_action_pressed("click") and hovering and !Globals.dragging_something:
		being_dragged = true
		Globals.dragging_something = true
	elif event.is_action_released("click"):
		being_dragged = false
		Globals.dragging_something = false

func _process(delta):
	if being_dragged: #and Globals.can_fire_gun:
		position = get_global_mouse_position()
		falling = true
		stopped = false
#		velocity = Vector2.ZERO
	else:
		if in_water:
			velocity.y += gravity / 2
		else:
			velocity.y += gravity
#			velocity.y = clamp(velocity.y, 0, 350)
#		var snap = Vector2.DOWN if is_on_floor() else Vector2.ZERO
#		velocity = move_and_slide_with_snap(velocity, snap, Vector2.UP)
#		if not stopped:
#		velocity.y = clamp(velocity.y, 0.0, 25.0)
		velocity = move_and_slide(velocity, Vector2.UP)
#	if !is_on_floor():
#		falling = true
	if falling and is_on_floor() and not Globals.firing_gun:
#		velocity = move_and_slide(Vector2.ZERO, Vector2.UP)
		falling = false
		$LandSounds.play()
#	var left_ray = $RayCast2D.get_collision_normal()
#	var right_ray = $RayCast2D2.get_collision_normal()
#	print(left_ray)
#	print(right_ray)
#	if left_ray == Vector2.ZERO or right_ray == Vector2.ZERO:
#		stopped = true

func set_texture():
	var v_frames = 10
	var h_frames = 10
	var my_frame
	if Globals.current_level == Globals.eye_planet:
		new_texture = load("res://assets/Environments/EyeWorld/EyeWorldTileMap.png")
		my_frame = 53
	elif Globals.current_level == Globals.alien_planet:
		new_texture = load("res://assets/Environments/AlienWorld/AlienWorldTileMap.png")
		my_frame = 53
	elif Globals.current_level == Globals.dream_planet:
		new_texture = load("res://assets/Environments/DreamWorld/DreamWorld.png")
		my_frame = 53
	elif Globals.current_level == Globals.candy_corn_planet:
		new_texture = load("res://assets/Environments/CandyCornWorld/CandyWorldTileMap1.png")
		my_frame = 64
	$Sprite.texture = new_texture
	$Sprite.vframes = v_frames
	$Sprite.hframes = h_frames
	$Sprite.frame = my_frame
#	$Sprite.texture = null

func _on_Area2D_mouse_entered():
	hovering = true

func _on_Area2D_mouse_exited():
	hovering = false
