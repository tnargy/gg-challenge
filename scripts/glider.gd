class_name Glider
extends GliderAndFireball


func getDirectionPriority(lt, ot) -> Array:
	return [lt, -2*lt, -1*ot]
	
