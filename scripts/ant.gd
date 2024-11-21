class_name Ant
extends Enemy

@export var walls: TileMapLayer
@export_enum("UP", "RIGHT", "DOWN", "LEFT") var starting_direction: String
@onready var sprite: Sprite2D = $Sprite2D
var size = 32
var speed = 0.75
var speed_delta = speed
var current_direction
var direction_order = [
	Vector2.UP,
	Vector2.RIGHT,
	Vector2.DOWN,
	Vector2.LEFT,
]
var left_target_tile: Vector2i
var forward_target_tile: Vector2i

func _ready():
	match starting_direction:
		"UP":
			current_direction = 0
		"RIGHT":
			current_direction = 1
			sprite.rotate(deg_to_rad(90))
		"DOWN":
			current_direction = 2
			sprite.rotate(deg_to_rad(180))
		"LEFT":
			current_direction = 3
			sprite.rotate(deg_to_rad(-90))


func _process(delta):
	speed_delta -= delta
	if speed_delta <= 0:
		speed_delta = speed
		move()


func move():
	var current_tile: Vector2i = walls.local_to_map(position)
	var direction = direction_order[current_direction]
	match direction:
		Vector2.UP:
			left_target_tile = Vector2i(current_tile.x - 1, current_tile.y)
			forward_target_tile = Vector2i(current_tile.x, current_tile.y - 1)
		Vector2.LEFT:
			left_target_tile = Vector2i(current_tile.x, current_tile.y + 1)
			forward_target_tile = Vector2i(current_tile.x - 1, current_tile.y)
		Vector2.DOWN:
			left_target_tile = Vector2i(current_tile.x + 1, current_tile.y)
			forward_target_tile = Vector2i(current_tile.x, current_tile.y + 1)
		Vector2.RIGHT:
			left_target_tile = Vector2i(current_tile.x, current_tile.y - 1)
			forward_target_tile = Vector2i(current_tile.x + 1, current_tile.y)
	if check_direction():
		position += direction_order[current_direction] * size
	
func check_direction() -> bool:
	var target_tile_data: TileData = walls.get_cell_tile_data(left_target_tile)
	if target_tile_data \
			and target_tile_data.get_custom_data("wall"):
		target_tile_data = walls.get_cell_tile_data(forward_target_tile)
		if target_tile_data \
				and target_tile_data.get_custom_data("wall"):
			current_direction = (current_direction + 1) % 4
			sprite.rotate(deg_to_rad(90))
			return false
		return true
	current_direction = (current_direction - 1) % 4
	sprite.rotate(deg_to_rad(-90))
	return true
