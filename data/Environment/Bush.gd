extends Area2D

var can_spawn_child = false
signal spawn_child

func _input(event):
	if event.is_action_pressed("interact"):
		if can_spawn_child:
			emit_signal("spawn_child")

func _on_Bush_body_entered(body):
	if body.name == "Player":
		can_spawn_child = true


func _on_Bush_body_exited(body):
	if body.name == "Player":
		can_spawn_child = false
