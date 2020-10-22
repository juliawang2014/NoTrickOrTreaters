extends Area2D

var can_select = false
var selected = false
export (Color) var selection_color
export (float) var scale_value = 0.5
var selectable = true

signal selection_made
signal deselect

func _ready():
	match name:
		"EyePlanet":
			if Globals.eye_finished:
				selectable = false
				modulate = Color.darkgray
		"AlienPlanet":
			if Globals.alien_finished:
				selectable = false
				modulate = Color.darkgray
		"CandyCornPlanet":
			if Globals.candycorn_finished:
				selectable = false
				modulate = Color.darkgray

func _physics_process(delta):
	control(delta)

func control(delta):
	if can_select and Input.is_action_just_pressed("click"):
		if selected:
			selected = false
			emit_signal("deselect")
		else:
			selected = true
			emit_signal("selection_made", name)
#	if selected:
#		modulate = selection_color
#	elif !selected:
#		modulate = Color.white

func do_tweening(value):
	$Tween.interpolate_property($Sprite, "scale", scale, Vector2(value,value),
		0.8, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
	$Tween.start()

func _on_Planet_mouse_entered():
	if selectable:
		can_select = true
		do_tweening(scale_value)


func _on_Planet_mouse_exited():
	if selectable:
		can_select = false
		do_tweening(1.0)
