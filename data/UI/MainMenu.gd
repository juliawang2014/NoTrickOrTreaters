extends ColorRect

signal play_pressed

func _on_Play_pressed():
	emit_signal("play_pressed")

func _on_Options_pressed():
	Options.reveal()
