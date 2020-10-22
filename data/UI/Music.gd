extends AudioStreamPlayer


func _ready():
	change_music(Globals.current_level)

func change_music(stage):
	match stage:
		Globals.dream_planet:
			var dream_ost = load("res://assets/Sounds/OST/DREAM WORL.wav")
			stream = dream_ost
		Globals.eye_planet:
			var eye_ost = load("res://assets/Sounds/OST/Eye World.wav")
			stream = eye_ost
		Globals.alien_planet:
			var alien_ost = load("res://assets/Sounds/OST/Alien Planet Loop.wav")
			stream = alien_ost
		Globals.candy_corn_planet:
			var candy_ost = load("res://assets/Sounds/OST/Halloween Ton.wav")
			stream = candy_ost
		Globals.level_select:
			var space_ost = load("res://assets/Sounds/OST/Menu for space.wav")
			stream = space_ost
		Globals.main_menu:
			var space_ost = load("res://assets/Sounds/OST/Menu for space.wav")
			stream = space_ost
	play()
