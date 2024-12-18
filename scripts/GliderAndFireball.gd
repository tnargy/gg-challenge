class_name GliderAndFireball
extends Enemy

@export var walls: TileMapLayer
@onready var raycast = $RayCast2D
@onready var size = raycast.target_position.length()

var current_direction
var speed = .25
var speed_delta = speed

func _ready():
	raycast.target_position = start_vector
	current_direction = raycast.target_position / size
		
		
func _physics_process(delta):
	if stuck: return
	current_direction = raycast.target_position / size
	if raycast.is_colliding():
		var target_obj = raycast.get_collider()
		var pos = position
		if get_parent().name == "Clone":
			pos = get_parent().position + position
		var current_tile: Vector2i = walls.local_to_map(pos)
		var target_tile: Vector2i = Vector2i(
			current_tile.x + current_direction.x,
			current_tile.y + current_direction.y,
		)
		var target_tile_data: TileData = walls.get_cell_tile_data(target_tile)
		if target_obj is Door or target_obj is Block:
			getNewDirection()
			return
		elif target_tile_data:
			if checkDeath(target_tile_data): return
			if target_tile_data.get_custom_data("wall"):
				getNewDirection()
				return
		else:
			getNewDirection()
			return
	speed_delta -= delta
	if speed_delta <= 0:
		speed_delta = speed
		position += current_direction * 2 * size


func getNewDirection():
	var left_target
	match current_direction:
		Vector2.UP:
			left_target = Vector2.LEFT * size
		Vector2.LEFT:
			left_target = Vector2.DOWN * size
		Vector2.RIGHT:
			left_target = Vector2.UP * size
		Vector2.DOWN:
			left_target = Vector2.RIGHT * size
		
	var orig_target_position: Vector2 = raycast.target_position
	var dirPriority = getDirectionPriority(left_target, orig_target_position)
	raycast.target_position = dirPriority[0]
	if not checkDirection():
		raycast.target_position = dirPriority[1]
		if not checkDirection():
			raycast.target_position = dirPriority[2]
			new_rotate(orig_target_position.angle_to(dirPriority[2]))
		else:
			new_rotate(orig_target_position.angle_to(dirPriority[1]))
	else:
		new_rotate(orig_target_position.angle_to(dirPriority[0]))


func new_rotate(new_rotation: float):
	var tween = create_tween()
	new_rotation += $Sprite2D.rotation
	tween.tween_property($Sprite2D, "rotation", new_rotation, 0.2)


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
		if target_obj is TileMapLayer:
			if target_tile_data.get_custom_data("wall"):
				return false
		elif target_obj is Door or target_obj is Block:
			return false
	return true
				

func getDirectionPriority(_lt, _ot) -> Array:
	return []

func checkDeath(_data: TileData) -> bool:
	return false
