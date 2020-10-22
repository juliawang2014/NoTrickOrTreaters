extends CanvasLayer

signal cutscene_done

var page = 0
var words = ""
var done = false

func _ready():
	next_slide()

func _input(event):
	if event.is_pressed() and $AnimationPlayer.is_playing():
		$AnimationPlayer.advance($AnimationPlayer.current_animation_length)
	elif event.is_pressed():
		next_slide()

func next_slide():
	pass

func transition(previous, next):
	if previous != null:
		$Tween.interpolate_property(previous, "modulate:a", previous.modulate.a, 
			0, 0.5,Tween.TRANS_LINEAR, Tween.EASE_IN)
	if next != null:
		$Tween.interpolate_property(next, "modulate:a", 0, 1, 0.5,
			Tween.TRANS_LINEAR,Tween.EASE_IN)
	$Tween.start()
