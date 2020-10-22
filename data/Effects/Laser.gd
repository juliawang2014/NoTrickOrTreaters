extends Node2D

const MAX_LENGTH = 3000

func _physics_process(delta):
	var mouse_position = get_local_mouse_position()
	var max_cast_to = mouse_position * MAX_LENGTH
	

