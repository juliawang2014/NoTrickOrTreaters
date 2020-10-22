extends Control

signal command_stay
signal command_follow

func _ready():
	connect("command_follow", Globals, "on_command_follow")
	connect("command_stay", Globals, "on_command_stay")
	emit_signal("command_follow")
	hide()

func _input(event):
	if event.is_action_pressed("command") and Globals.current_level != Globals.dream_planet:
		appear()

func appear():
	show()
	$AnimationPlayer.play("fade")

func disappear():
	$AnimationPlayer.play_backwards("fade")
	hide()

func _on_Stay_pressed():
	emit_signal("command_stay")
	disappear()

func _on_Follow_pressed():
	emit_signal("command_follow")
	disappear()

