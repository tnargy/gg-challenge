class_name Ant
extends Enemy

@export var walls: TileMapLayer
@onready var raycast: RayCast2D = $RayCast2D

var current_direction
var speed = .25
var speed_delta = speed
var size

func _ready():
	$Sprite2D.rotation = (raycast.target_position.angle_to(start_vector)) + deg_to_rad(90)
	raycast.target_position = start_vector
	raycast.force_raycast_update()
	size = raycast.target_position.length()

func _physics_process(delta):
	if stuck: return
	current_direction = (raycast.target_position / size)
	var ray = raycast.target_position
	if raycast.is_colliding():
		raycast.target_position = Vector2(-1 * raycast.target_position.y, raycast.target_position.x)
		if checkDirection():
			raycast.target_position = ray
			current_direction = Vector2(-1 * current_direction.y, current_direction.x)
			move(delta)
		else:
			$Sprite2D.rotation += deg_to_rad(90)
	else:
		if move(delta):
			raycast.target_position = -1 * Vector2(-1 * raycast.target_position.y, raycast.target_position.x)
			$Sprite2D.rotation += deg_to_rad(-90)


func move(delta: float) -> bool:
	speed_delta -= delta
	if speed_delta <= 0:
		speed_delta = speed
		position += current_direction  * size
		return true
	return false
	
	
func checkDirection() -> bool:
	raycast.force_raycast_update()
	if raycast.is_colliding():
		var target_obj = raycast.get_collider()
		var current_tile: Vector2i = walls.local_to_map(position)
		var target_tile: Vector2i = Vector2i(
			current_tile.x + int(raycast.target_position.x / size),
			current_tile.y + int(raycast.target_position.y / size),
		)
		var target_tile_data = walls.get_cell_tile_data(target_tile)
		checkDeath(target_tile_data)
		if target_obj is TileMapLayer:
			if target_tile_data.get_custom_data("wall") \
				or target_tile_data.get_custom_data("gravel") \
				or target_tile_data.get_custom_data("fire"):
					return false
		elif target_obj is Door \
			or target_obj is Block \
			or target_obj is Enemy:
				return false
	return true
				

func checkDeath(target_tile_data: TileData) -> bool:
	if target_tile_data.get_custom_data("water"):
		queue_free()
		return true
	return false
