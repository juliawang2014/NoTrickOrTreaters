extends "res://data/UI/Cutscene.gd"

func next_slide():
	match page:
		0:
			transition(null, $Scenes/Scene0)
			page = 1
			words = "[center]There was once a scientist who experimented in his lab peacefully[/center]"
		1:
			transition($Scenes/Scene0, $Scenes/Scene1)
			page = 2
			words = "[center]He created a dream planet where all his precious hopes and dreams laid[/center]"
		2:
			transition($Scenes/Scene1, $Scenes/Scene2)
			page = 3
			words = "[center]On Halloween three children ignored his lab sign that there was no candy and asked for candy[/center]"
		3:
			transition($Scenes/Scene2, $Scenes/Scene3)
			page = 4
			words = "[center]The scientist gave the kids candy hoping that they would leave soon[/center]"
		4:
			transition($Scenes/Scene3, $Scenes/Scene4)
			page = 5
			words = "[center]But after they got the candy they frolicked on the dream planet[/center]"
		5:
			transition($Scenes/Scene4, null)
			page = 6
			words = "[center]The scientist then knew that he had to get them off his dream planet and return them home[/center]"
		6:
			done = true
			words = ""
			emit_signal("cutscene_done", name)
	if not done:
		$Story.bbcode_text = words
		$AnimationPlayer.playback_speed = 60.0 / words.length()
		$AnimationPlayer.play("appear")


