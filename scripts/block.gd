class_name Block
extends Area2D

@export var walls: TileMapLayer
var prev_pos: Vector2

func _process(_delta):
	var current_tile: Vector2i = walls.local_to_map(position)
	var target_tile_data: TileData = walls.get_cell_tile_data(current_tile)
	
	if target_tile_data != null:
		if target_tile_data.get_custom_data("water"):
			queue_free()
			walls.set_cell(current_tile, 1, Vector2i(0,11))
	
	
func update_prev_pos():
	prev_pos = position
	
	
func teleport(new_pos: Vector2):
	position = new_pos + (position - prev_pos)
	
