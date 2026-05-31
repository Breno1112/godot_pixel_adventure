extends Camera2D

@export var tilemap: TileMapLayer

func _ready() -> void:
	if tilemap == null:
		push_error("TileMapLayer not assigned!")
		return

	var used_rect = tilemap.get_used_rect()
	var tile_size = tilemap.tile_set.tile_size

	var map_left = tilemap.global_position.x + used_rect.position.x * tile_size.x
	var map_top = tilemap.global_position.y + used_rect.position.y * tile_size.y

	var map_right = tilemap.global_position.x + (used_rect.position.x + used_rect.size.x) * tile_size.x
	var map_bottom = tilemap.global_position.y + (used_rect.position.y + used_rect.size.y) * tile_size.y

	limit_left = int(map_left)
	limit_top = int(map_top)
	limit_right = int(map_right)
	limit_bottom = int(map_bottom)

	print("Left: ", limit_left)
	print("Top: ", limit_top)
	print("Right: ", limit_right)
	print("Bottom: ", limit_bottom)
