extends TileMap

func _ready():
#	modulate = Color.white
	pass

func destroy():
	call_deferred('free')
