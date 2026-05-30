extends Camera2D

@onready var tile_map_layer: TileMapLayer = $"../../TileMapLayer"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if tile_map_layer:
		# Get the used rectangle of the tilemap
		var map_rect = tile_map_layer.get_used_rect()
		var cell_size = tile_map_layer.tile_set.tile_size
		
		# Calculate pixel boundaries
		limit_left = int(map_rect.position.x * cell_size.x * zoom.x)
		limit_top = int(map_rect.position.y * cell_size.y * zoom.y)
		limit_right = int(map_rect.end.x * cell_size.x * zoom.x)
		limit_bottom = int(map_rect.end.y * cell_size.y * zoom.y)
		print("limit_left: ", limit_left)
		print("limit_right: ", limit_right)
		print("limit_top: ", limit_top)
		print("limit_bottom: ", limit_bottom)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
