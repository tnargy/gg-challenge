class_name Teeth
extends Enemy

@export var walls: TileMapLayer
@export var player: Player
@onready var sprite: Sprite2D = $Sprite2D
@onready var raycast: RayCast2D = $RayCast2D

var size = 32
var current_direction
var speed = .5
var speed_delta = speed
		
func _physics_process(delta):
	if stuck: return
	raycast.target_position = (player.global_position - global_position) / 2
	current_direction = update_direction()
	if raycast.is_colliding(): 
		var target_obj = raycast.get_collider()
		var current_tile: Vector2i = walls.local_to_map(position)
		var target_tile: Vector2i = Vector2i(
			current_tile.x + current_direction.x,
			current_tile.y + current_direction.y,
		)
		var target_tile_data: TileData = walls.get_cell_tile_data(target_tile)
		if target_tile_data:
			if target_tile_data.get_custom_data("fire"):
				queue_free()
				return
			elif target_tile_data.get_custom_data("wall") \
				or target_tile_data.get_custom_data("water") \
				or target_tile_data.get_custom_data("mud") \
				or target_tile_data.get_custom_data("gravel"):
					return
		elif target_obj is Block \
			or target_obj is Item \
			or target_obj is Door:
				return

	speed_delta -= delta
	if speed_delta <= 0:
		speed_delta = speed
		position += current_direction * size


func update_direction() -> Vector2:
	var y_diff = player.position.y - position.y
	var x_diff = player.position.x - position.x
	
	if abs(y_diff) > abs(x_diff):
		if player.position.y < position.y:
			sprite.set_region_rect(Rect2(256,128,32,32))
			return Vector2.UP
		elif player.position.y > position.y:
			sprite.set_region_rect(Rect2(256,192,32,32))
			return Vector2.DOWN
	elif abs(y_diff) < abs(x_diff):
		if player.position.x > position.x:
			sprite.set_region_rect(Rect2(256,224,32,32))
			return Vector2.RIGHT
		elif player.position.x < position.x:
			sprite.set_region_rect(Rect2(256,160,32,32))
			return Vector2.LEFT
	else:
		if player.position.y < position.y:
			sprite.set_region_rect(Rect2(256,128,32,32))
			return Vector2.UP
		elif player.position.y > position.y:
			sprite.set_region_rect(Rect2(256,192,32,32))
			return Vector2.DOWN
		
		elif player.position.x > position.x:
			sprite.set_region_rect(Rect2(256,224,32,32))
			return Vector2.RIGHT
		elif player.position.x < position.x:
			sprite.set_region_rect(Rect2(256,160,32,32))
			return Vector2.LEFT
	return Vector2.ZERO
