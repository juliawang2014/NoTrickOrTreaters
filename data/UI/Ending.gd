extends "res://data/UI/Cutscene.gd"

func next_slide():
	match page:
		0:
			transition(null, $Scenes/Scene0)
			page = 1
			words = "[center]With the kids returned to their homes the scientist could return to his lab[/center]"
		1:
			transition($Scenes/Scene0, $Scenes/Scene1)
			page = 2
			words = "[center]He was free to conduct his experiments alone in peace[/center]"
		2:
			transition($Scenes/Scene1, $Scenes/Scene2)
			page = 3
			words = "[center]Until next Halloween[/center]"
		3:
			done = true
			words = ""
			emit_signal("cutscene_done", name)
	if not done:
		$Story.bbcode_text = words
		$AnimationPlayer.playback_speed = 60.0 / words.length()
		$AnimationPlayer.play("appear")
