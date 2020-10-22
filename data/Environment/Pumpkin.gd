extends RigidBody2D

var hovering = false
var being_dragged = false
var in_water = false

func _input(event):
	if event.is_action_pressed("click") and hovering and !Globals.dragging_something:
		being_dragged = true
		Globals.dragging_something = true
	elif event.is_action_released("click"):
		being_dragged = false
		Globals.dragging_something = false

func _process(delta):
	if being_dragged: #and Globals.can_fire_gun:
		position = get_global_mouse_position()
		sleeping = true
	else:
		sleeping = false
#		velocity = Vector2.ZERO

func _on_Area2D_mouse_entered():
	hovering = true


func _on_Area2D_mouse_exited():
	hovering = false
