class_name Player
extends Area2D

@export var walls: TileMapLayer
@onready var level = $".."
@onready var sprite: Sprite2D = $Sprite2D
@onready var raycast: RayCast2D = $RayCast2D

var size = 32
var inputs = {"Up": Vector2.UP,
			"Right": Vector2.RIGHT,
			"Down": Vector2.DOWN,
			"Left": Vector2.LEFT}
var inventory: Dictionary

func _ready():
	inventory = {
		"BLUE":0, "YELLOW":0, "GREEN":0, "RED":0,
		"FLIPPERS":0, "FIRESHOES":0, "SKATES":0, "SUCTION":0}

func _handle_item_collected(type: String):
	if type == "CHIP":
		level.chips_needed -= 1
	else:
		inventory[type] += 1
			
func _input(event):
	for dir in inputs.keys():
		if event.is_action_pressed(dir):
			move(dir)

func move(dir):
	var current_tile: Vector2i = walls.local_to_map(position)
	var target_tile: Vector2i = Vector2i(
		current_tile.x + inputs[dir].x,
		current_tile.y + inputs[dir].y,
	)
	var target_tile_data: TileData = walls.get_cell_tile_data(target_tile)
	
	match dir:
		"Up":
			sprite.set_region_rect(Rect2(192,384,32,32))
		"Left":
			sprite.set_region_rect(Rect2(192,416,32,32))
		"Right":
			sprite.set_region_rect(Rect2(192,480,32,32))
		_:
			sprite.set_region_rect(Rect2(192,448,32,32))

	# Prevent passing through walls
	if target_tile_data.get_custom_data("wall"):
		return
	
	# Check to see if you are at a door
	raycast.target_position = inputs[dir] * size
	raycast.force_raycast_update()
	if raycast.is_colliding():
		var door: Door = raycast.get_collider()
		if door.door_color == "GATE":
			if level.chips_needed <= 0:
				door.queue_free() # Goal Complete
			else:
				return # Goal Incomplete
		elif inventory[door.door_color] > 0:
			inventory[door.door_color] -= 1
			door.queue_free() # Open door
		else:
			return # Block movement
	
	position += inputs[dir] * size
