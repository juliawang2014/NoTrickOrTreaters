extends ColorRect

signal play_pressed

func _on_Play_pressed():
	$MenuSound.play()
	emit_signal("play_pressed")

func _on_Options_pressed():
	$MenuSound.play()
	Options.reveal()

