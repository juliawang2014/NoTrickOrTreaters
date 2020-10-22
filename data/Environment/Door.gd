extends TileMap



func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "disappear":
		call_deferred('free')
