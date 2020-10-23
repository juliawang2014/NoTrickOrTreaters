extends Sprite


func _on_AnimationPlayer_animation_finished(anim_name):
	call_deferred('free')
