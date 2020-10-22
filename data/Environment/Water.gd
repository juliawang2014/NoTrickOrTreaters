extends Area2D

onready var splash = preload("res://data/Effects/Splash.tscn")
var splash_instance
#export (float) var buoyancy = 300
#var parent = get_parent()
#signal water_ready
#
#func _ready():
#	emit_signal("water_ready")
#	var square = RectangleShape2D.new()
#	$CollisionShape2D.shape = square
#	$CollisionShape2D.shape.extents.x = parent.get_used_rect().size.x / 2
#	$CollisionShape2D.shape.extents.y = parent.get_used_rect().size.y / 2
#	position = parent.get_used_rect().position
	
signal splashed

func _on_Water_body_entered(body):
	body.in_water = true

func _on_Water_body_exited(body):
	body.in_water = false


#func _on_Water_area_shape_entered(area_id, area, area_shape, self_shape):
#	if area.name == "Feet":
#		splash_instance = splash.instance()
#		splash_instance.start(area.position)
#		call_deferred('add_child', splash_instance)
#		var area_shape_owner_id = area.shape_find_owner(area_shape)
#		var area_shape_owner = area.shape_owner_get_owner(area_shape_owner_id)
#		var area_shape_2d = area.shape_owner_get_shape(area_shape_owner_id, 0)
#		var area_global_transform = area_shape_owner.global_transform
#
#		var this_area_shape_owner_id = shape_find_owner(self_shape)
#		var this_area_shape_owner = shape_owner_get_owner(this_area_shape_owner_id)
#		var this_area_shape_2d = shape_owner_get_shape(this_area_shape_owner_id, 0)
#		var this_area_global_transform = this_area_shape_owner.global_transform
#
#		var collision_points = this_area_shape_2d.collide_and_get_contacts(this_area_global_transform,
#																			area_shape_2d,
#																			area_global_transform)
#		for i in collision_points.size():
#			var point = collision_points[i]
#			splash_instance.position = point
#			print(point)
#			print(splash_instance.position)
#			call_deferred('add_child', splash_instance)


func _on_Water_area_entered(area):
	if area.name == "Feet":
		emit_signal("splashed", area)
#		print(area.name)
#		splash_instance = splash.instance()
##		splash_instance.global_position = area.global_position
#		print("W: %f" % area.global_position.x)
#		call_deferred('add_child', splash_instance)
