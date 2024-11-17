class_name Block
extends Area2D

@onready var walls = $"../Walls"

func _process(_delta):
	var current_tile: Vector2i = walls.local_to_map(position)
	var target_tile_data: TileData = walls.get_cell_tile_data(current_tile)
	
	if target_tile_data.get_custom_data("water"):
		queue_free()
		walls.set_cell(current_tile, 1, Vector2i(0,11))
