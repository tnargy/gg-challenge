class_name Player
extends Area2D

@export var walls: TileMapLayer
@onready var level = $".."
@onready var sprite: Sprite2D = $Sprite2D
@onready var raycast: RayCast2D = $RayCast2D

signal inventory_changed
signal death

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
		inventory_changed.emit(type, inventory[type])
			
func _input(event):
	for dir in inputs.keys():
		if event.is_action_pressed(dir):
			move(dir)

func move(dir):
	# Turn Sprite
	match dir:
		"Up":
			sprite.set_region_rect(Rect2(192,384,32,32))
		"Left":
			sprite.set_region_rect(Rect2(192,416,32,32))
		"Right":
			sprite.set_region_rect(Rect2(192,480,32,32))
		_:
			sprite.set_region_rect(Rect2(192,448,32,32))
			
	if not _raycast_check(inputs[dir]):
		return	# Can't move that way
	
	position += inputs[dir] * size
	
	
func _raycast_check(dir: Vector2) -> bool:
	raycast.target_position = dir * size
	raycast.force_raycast_update()
	if raycast.is_colliding():
		var target_obj = raycast.get_collider()
		var current_tile: Vector2i = walls.local_to_map(position)
		var target_tile: Vector2i = Vector2i(
			current_tile.x + dir.x,
			current_tile.y + dir.y,
		)
		var target_tile_data: TileData = walls.get_cell_tile_data(target_tile)
		# Walking into door
		if target_obj is Door:
			if target_obj.door_color == "GATE":
				if level.chips_needed <= 0:
					target_obj.queue_free() # Goal Complete
				else:
					return false# Goal Incomplete
			elif inventory[target_obj.door_color] > 0:
				inventory[target_obj.door_color] -= 1
				inventory_changed.emit(target_obj.door_color, inventory[target_obj.door_color])
				target_obj.queue_free()	# Open door
			else:
				return false	# Door Locked
		# Walking into block
		elif target_obj is Block:
			# Check push direction
			_toggle_look_ahead(true, target_obj)
			
			if raycast.is_colliding():
				var new_target_obj = raycast.get_collider()
				target_tile = Vector2i(
					target_tile.x + dir.x,
					target_tile.y + dir.y,
				)
				target_tile_data = walls.get_cell_tile_data(target_tile)
				if new_target_obj is TileMapLayer:
					if target_tile_data.get_custom_data("wall") or target_tile_data.get_custom_data("mud"):
						_toggle_look_ahead(false)
						return false	# Object on other side of Block
				elif new_target_obj is Block or new_target_obj is Door:
					_toggle_look_ahead(false)
					return false	# Object on other side of Block
			target_obj.position += dir * size
			_toggle_look_ahead(false)
		# Walking into a TileMap (ie wall/water/mud )
		elif target_obj is TileMapLayer:
			if target_tile_data.get_custom_data("wall"):
				return false	# Wall
			elif target_tile_data.get_custom_data("water"):
				walls.set_cell(target_tile, 1, Vector2i(3,3))
				sprite.visible = false
				death.emit()
			elif target_tile_data.get_custom_data("mud"):
				# Change mud into flooring
				walls.set_cell(target_tile, 1, Vector2i(0,0))
				
	return true	# Nothing in way
	

func _toggle_look_ahead(enable: bool, target_obj: Object = null):
	if enable:
		raycast.add_exception(target_obj)
		raycast.target_position = raycast.target_position * 2
	else:
		raycast.clear_exceptions()
		raycast.target_position = raycast.target_position / 2
	raycast.force_raycast_update()
