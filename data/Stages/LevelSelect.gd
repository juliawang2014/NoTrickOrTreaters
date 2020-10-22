extends Node2D

var ending = preload("res://data/UI/Ending.tscn")
var ending_instance
var opening = preload("res://data/UI/Opening.tscn")
var opening_instance

func _ready():
	Music.change_music(Globals.current_level)
	if Globals.current_level == Globals.main_menu:
		$Control.show()
	else:
		$Control.hide()
	if Globals.eye_finished and Globals.alien_finished and Globals.candycorn_finished:
#		$Control2.show()
		ending_instance = ending.instance()
		ending_instance.connect("cutscene_done", self, "_on_cutscene_done")
		call_deferred('add_child', ending_instance)

func _on_Planet_selection_made(planet_name):
	match planet_name:
		"CandyCornPlanet":
			Globals.current_level = Globals.candy_corn_planet
			zoom_in(planet_name)
			yield(get_tree().create_timer(2.0),"timeout")
			get_tree().change_scene("res://data/Stages/CandyCornLevel.tscn")
		"EyePlanet":
			Globals.current_level = Globals.eye_planet
			zoom_in(planet_name)
			yield(get_tree().create_timer(2.0),"timeout")
			
			get_tree().change_scene("res://data/Stages/EyeWorld.tscn")
			
		"LabPlanet":
#			Globals.current_level = Globals.dream_planet
			zoom_in(planet_name)
			yield(get_tree().create_timer(2.0),"timeout")
			opening_instance = opening.instance()
			opening_instance.connect("cutscene_done", self, "_on_cutscene_done")
			call_deferred('add_child', opening_instance)
#			get_tree().change_scene("res://data/Stages/DreamPlanet.tscn")
			
		"AlienPlanet":
			Globals.current_level = Globals.alien_planet
			zoom_in(planet_name)
			yield(get_tree().create_timer(2.0),"timeout")
			
			get_tree().change_scene("res://data/Stages/AlienPlanet.tscn")
		"DreamPlanet":
			Globals.current_level = Globals.dream_planet
			zoom_in(planet_name)
			yield(get_tree().create_timer(2.0),"timeout")
			get_tree().change_scene("res://data/Areas/DreamPlanet.tscn")
			


func _on_MainMenu_play_pressed():
	$Control.hide()
	Globals.new_game()
	_on_Planet_selection_made("LabPlanet")
	

func zoom_in(planet):
	var target_planet = $Planets.get_node(planet)
	var target_position = target_planet.position
	$Camera2D/Tween.interpolate_property($Camera2D, "position", $Camera2D.position,
		target_position, 2.0, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	$Camera2D/Tween.interpolate_property($Camera2D, "zoom", $Camera2D.zoom, Vector2(0.4,0.4),
			1.8, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	$Camera2D/Tween.start()


func _on_Credits_return_from_credits():
	$Control.show()
#	$Control2.call_deferred('free')

func _on_cutscene_done(cutscene):
	match cutscene:
		"Ending":
			ending_instance.call_deferred('free')
			$Control2.show()
		"Opening":
			Globals.current_level = Globals.dream_planet
			get_tree().change_scene("res://data/Stages/DreamPlanet.tscn")
			
			
