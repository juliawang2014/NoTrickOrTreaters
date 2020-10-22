extends Sprite

#func start(_position):
#	position = _position

func _on_AnimationPlayer_animation_finished(anim_name):
	call_deferred('free')
