extends CanvasModulate

func use_tween(new_color):
	$Tween.interpolate_property(self, "color", color,
		new_color, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()
