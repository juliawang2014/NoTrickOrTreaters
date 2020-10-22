extends Sprite

var firing = false
var moving_block = false
signal on_left_side
signal on_right_side
signal move_block

func _ready():
	if Globals.current_level == Globals.dream_planet:
		texture = load("res://assets/Actor/ScientistArm.png")
	else:
		texture = load("res://assets/Actor/ScientistArmWithGun.png")

func _input(event):
	if event.is_action_pressed("click") and Globals.current_level != Globals.dream_planet:
		Globals.firing_gun = true
		$Laser.visible = true
	elif event.is_action_released("click"):
		Globals.firing_gun = false
		$Laser.visible = false

func _process(delta):
#	get_muzzle_position()
	look_at(get_global_mouse_position())
	if get_muzzle_position():
		flip_v = true
	else:
		flip_v = false
	if Globals.current_level != Globals.dream_planet:
		if Globals.firing_gun: #and firing_status():
			$RayCast2D.cast_to = get_local_mouse_position()
			var target = $RayCast2D.get_collider()
			if target and (target is TileMap or target.name == "Block") and !moving_block:
				moving_block = true
				if target is TileMap and !Globals.dragging_something:
					var tile_pos
	#				if get_muzzle_position():
	#					tile_pos = target.world_to_map($RayCast2D.get_collision_point()) #- Vector2(1,0)
	#				else:
	#					tile_pos = target.world_to_map($RayCast2D.get_collision_point())
					tile_pos = target.world_to_map($Laser/End/TileTarget.global_position)
					target.set_cellv(tile_pos, TileMap.INVALID_CELL)
	#				print(tile_pos)
					emit_signal("move_block")
		else:
			moving_block = false
			$RayCast2D.cast_to = Vector2(0,0)
		
		if $RayCast2D.is_colliding():
			$Laser/End.global_position = $RayCast2D.get_collision_point()
		else:
			$Laser/End.global_position = get_global_mouse_position()
		
	#	$Laser/Beam.rotation = $RayCast2D.cast_to.angle()
		$Laser/Beam.region_rect.end.x = $Laser/End.position.length() - $Laser/Beam.offset.x


func get_muzzle_position():
	var status
	var muzzle_tip = global_position.direction_to($Muzzle.global_position)
	var dot_product = muzzle_tip.dot(Vector2.LEFT)
	if dot_product >= 0:
		status = true
		emit_signal("on_left_side")
	else:
		status = false
		emit_signal("on_right_side")
	return status


func firing_status():
	var muzzle_tip = global_position.direction_to($Muzzle.global_position)
	var dot_product = muzzle_tip.dot(Vector2.DOWN)
	if dot_product > 0.4:
		Globals.can_fire_gun = false
	else:
		Globals.can_fire_gun = true
	return Globals.can_fire_gun
