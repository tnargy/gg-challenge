class_name Fireball
extends GliderAndFireball


func getDirectionPriority(lt, ot) -> Array:
	return [-2*lt, lt, -1*ot]


func checkDeath(target_tile_data: TileData) -> bool:
	if target_tile_data.get_custom_data("water"):
		queue_free()
		return true
	return false
