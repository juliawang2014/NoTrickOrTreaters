extends TileMap

export (PackedScene) var tile

func _ready():
#	for i in get_child_count():
#		var child = get_child(i)
#		print("CATS")
#		if child.has_signal("water_ready"):
#			child.connect("water_ready", self, "_on_Water_ready")
#			print("DOGS")
	pass

func _on_Water_ready():
	var square = RectangleShape2D.new()
	$Water/CollisionShape2D.shape = square
	$Water/CollisionShape2D.shape.extents.x = get_used_rect().size.x / 2
	$Water/CollisionShape2D.shape.extents.y = get_used_rect().size.y / 2
	$Water.position = get_used_rect().position
	print("WHAT")

func replace_tiles():
	var cells = get_used_cells()
	
	clear()
	
	for cell in cells:
		var new_tile = tile.instance()
		add_child(new_tile)
		new_tile.global_position = Vector2((cell.x + 0.5) * cell_size.x, (cell.y + 0.5) * cell_size.y)
