extends Node

var can_fire_gun

var dragging_something = false
var firing_gun = false

var candycorn_finished = false
var eye_finished = false
var alien_finished = false
var current_level = 0
var main_menu = 0
var lab = 1
var dream_planet = 2
var eye_planet = 3
var candy_corn_planet = 4
var alien_planet = 5
var level_select = 6
var player_pos = Vector2()
var follow = true
var stay = false
var restarted = false

func _ready():
	current_level = main_menu

func new_game():
	candycorn_finished = false
	eye_finished = false
	alien_finished = false

func pause():
	get_tree().paused = true

func unpause():
	get_tree().paused = false

func on_command_follow():
	stay = false
	follow = true

func on_command_stay():
	stay = true
	follow = false
