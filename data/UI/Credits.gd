extends Control

signal return_from_credits

func _on_ReturnToMain_pressed():
	hide()
	emit_signal("return_from_credits")
