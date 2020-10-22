extends CanvasLayer

var hidden_pos = Vector2(0, -96)
var shown_pos = Vector2.ZERO
var shown = false
export (float) var show_time = 0.4

func _ready():
	$NinePatchRect.rect_position = hidden_pos
	if Globals.current_level == Globals.dream_planet:
		$NinePatchRect/HBoxContainer/ReturnToSpace.disabled = true
	else:
		$NinePatchRect/HBoxContainer/ReturnToSpace.disabled = false

func _input(event):
	if event.is_action_pressed("pause"):
		toggle()

func toggle():
	shown = !shown
	tween_hud(shown)

func tween_hud(down):
	if down:
		$Tween.interpolate_property($NinePatchRect, "rect_position", $NinePatchRect.rect_position, 
			shown_pos, show_time, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	else:
		$Tween.interpolate_property($NinePatchRect, "rect_position", $NinePatchRect.rect_position, 
			hidden_pos, show_time, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.start()


func _on_Resume_pressed():
	toggle()

func _on_Restart_pressed():
	Globals.restarted = true
	get_tree().reload_current_scene()


func _on_ReturnToSpace_pressed():
	Globals.current_level = Globals.level_select
	get_tree().change_scene("res://data/Stages/LevelSelect.tscn")


func _on_ReturnToMain_pressed():
	Globals.current_level = Globals.main_menu
	get_tree().change_scene("res://data/Stages/LevelSelect.tscn")


func _on_Options_pressed():
	Options.reveal()
