extends Node2D

var block = preload("res://data/Environment/Block.tscn")
var block_instance
onready var splash = preload("res://data/Effects/Splash.tscn")
var splash_instance
onready var eye_child = preload("res://data/Actors/EyeChild.tscn")
var child_count = 0
var pumpkin_counter = 0
var pump_counter_beta = 0
var pumpkin_vent_activated = false
var green_door_gone = false
var plain_door_gone = false
var bush_clicked = false

func _ready():
	if not Globals.restarted:
		Music.change_music(Globals.current_level)
	set_camera_limits()
	$Player/Gun.connect("move_block", self, "_on_block_moved")
	for i in $WaterTexture.get_child_count():
		var child = $WaterTexture.get_child(i)
		if child is Area2D:
			child.connect("splashed", self, "_on_water_splash")
	if Globals.current_level == Globals.dream_planet:
		$CandyCornChild.connect("captured", self, "_on_child_captured")
		$AlienChild.connect("captured", self, "_on_child_captured")
	Globals.restarted = false

func _on_block_moved():
	block_instance = block.instance()
	block_instance.position = get_global_mouse_position()
	#block_instance.new_texture = target.tile_set.tile_get_texture(2)
	$Blocks.call_deferred('add_child', block_instance)

func _on_water_splash(area):
	splash_instance = splash.instance()
	splash_instance.position = area.global_position
	call_deferred('add_child', splash_instance)

func set_camera_limits():
	var map_limits = $StaticGroundTiles.get_used_rect()
	var map_cellsize = $StaticGroundTiles.cell_size
	$Player/Camera2D.limit_left = map_limits.position.x * map_cellsize.x
	$Player/Camera2D.limit_right = map_limits.end.x * map_cellsize.x
	$Player/Camera2D.limit_bottom = map_limits.end.y * map_cellsize.y


func _on_KillFloor_body_entered(body):
	if body.name == "Player":
		get_tree().reload_current_scene()


func _on_CaveZone_body_exited(body):
	if body.name == "Player":
		$CanvasModulate.use_tween(Color.white)
		$Player/Light2D.enabled = false


func _on_CaveZone_body_entered(body):
	if body.name == "Player":
		$CanvasModulate.use_tween(Color("292929"))
		$Player/Light2D.enabled = true


func _on_EndZone_body_entered(body):
	if body.name == "EyeChild" or body.name == "AlienChild" or body.name == "CandyCornChild":
		$Polygon2D.visible = true
		match body.name:
			"EyeChild":
				Globals.eye_finished = true
			"AlienChild":
				Globals.alien_finished = true
			"CandyCornChild":
				Globals.candycorn_finished = true
		yield(get_tree().create_timer(5.0),"timeout")
		Globals.current_level = Globals.level_select
		get_tree().change_scene("res://data/Stages/LevelSelect.tscn")


func _on_VentArea_body_entered(body):
	if body.name == "Player" or body.name == "AlienChild":
		body.jump_forever(true)
		

func _on_Ceiling_body_entered(body):
	if body.name == "Player" or body.name == "AlienChild" or body.name == "CandyCornChild":
		body.jump_forever(false)

func _on_child_captured(times_caught):
	if times_caught == 1:
		child_count += 1
		if child_count == 3:
			yield(get_tree().create_timer(4.0),"timeout")
			Globals.current_level = Globals.level_select
			get_tree().change_scene("res://data/Stages/LevelSelect.tscn")

func _on_Bush_spawn_child():
	if not bush_clicked:
		bush_clicked = true
		var eye_instance = eye_child.instance()
		eye_instance.global_position = $Bush.global_position
		eye_instance.connect("captured", self, "_on_child_captured")
		call_deferred('add_child', eye_instance)
		$Bush/AnimationPlayer.stop()



func _on_PumpkinContainer_body_entered(body):
	if body is RigidBody2D:
		pumpkin_counter += 1
	if pumpkin_counter == 4:
		$Door/AnimationPlayer.play("disappear")

func _on_PumpkinAltar_body_entered(body):
	if body.name == "PlainPumpkin" and not plain_door_gone:
		plain_door_gone = true
		$Door3/AnimationPlayer.play("disappear")
	elif body.name == "GreenPumpkin" and not green_door_gone:
		green_door_gone = true
		$Door2/AnimationPlayer.play("disappear")
	elif (body.name == "Player" or body.name == "CandyCornChild") and pumpkin_vent_activated:
		body.jump_forever(true)


func _on_PumpContainer2_body_entered(body):
	if body is RigidBody2D:
		pump_counter_beta += 1
	if pump_counter_beta == 4:
		$WaterTexture2.visible = true
		pumpkin_vent_activated = true
#		$StaticBody2D/CollisionShape2D.one_way_collision = true
		$StaticBody2D/CollisionShape2D.set_deferred("one_way_collision", true)

