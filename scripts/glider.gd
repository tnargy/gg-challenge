class_name Glider
extends GliderAndFireball


func getDirectionPriority(lt, ot) -> Array:
	return [lt, -2*lt, -1*ot]
	
	
func checkDeath():
	var current_tile: Vector2i = walls.local_to_map(position)
	var target_tile_data = walls.get_cell_tile_data(current_tile)
	if target_tile_data and target_tile_data.get_custom_data("fire"):
		queue_free()
