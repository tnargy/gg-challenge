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
var swimming = false
var sliding = false
var stuck: bool = false

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
	if event.is_action_pressed("Restart"): level._restart_level()
	if sliding: return
	
	for dir in inputs.keys():
		if event.is_action_pressed(dir):
			move(inputs[dir])

func update_direction(dir: Vector2):
	match dir:
		Vector2.UP:
			if swimming:
				sprite.set_region_rect(Rect2(192-96,384,32,32))
			else:
				sprite.set_region_rect(Rect2(288,384,32,32))
		Vector2.LEFT:
			if swimming:
				sprite.set_region_rect(Rect2(192-96,416,32,32))
			else:
				sprite.set_region_rect(Rect2(288,416,32,32))
		Vector2.RIGHT:
			if swimming:
				sprite.set_region_rect(Rect2(192-96,480,32,32))
			else:
				sprite.set_region_rect(Rect2(288,480,32,32))
		Vector2.DOWN:
			if swimming:
				sprite.set_region_rect(Rect2(192-96,448,32,32))
			else:
				sprite.set_region_rect(Rect2(288,448,32,32))
			
			
func move(dir: Vector2):
	if raycast_check(dir) and not stuck:
		position += dir * size
	update_direction(dir)
	
func raycast_check(dir: Vector2) -> bool:
	raycast.target_position = dir * size
	raycast.force_raycast_update()
	if raycast.is_colliding():
		var target_obj = raycast.get_collider()
		var current_tile: Vector2i = walls.local_to_map(position)
		var target_tile: Vector2i = Vector2i(
			current_tile.x + int(dir.x),
			current_tile.y + int(dir.y),
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
			toggle_look_ahead(true, target_obj)
			if raycast.is_colliding():
				var new_target_obj = raycast.get_collider()
				target_tile = Vector2i(
					target_tile.x + int(dir.x),
					target_tile.y + int(dir.y),
				)
				target_tile_data = walls.get_cell_tile_data(target_tile)
				if new_target_obj is TileMapLayer:
					if target_tile_data.get_custom_data("wall") or target_tile_data.get_custom_data("mud"):
						toggle_look_ahead(false)
						return false	# Object on other side of Block
				elif new_target_obj is Block or new_target_obj is Door or new_target_obj is ToggleWall:
					toggle_look_ahead(false)
					return false	# Object on other side of Block
			target_obj.position += dir * size
			toggle_look_ahead(false)
		elif target_obj is ToggleWall and target_obj.toggle:
			return false
		elif target_obj is Clone:
			return false
		# Walking into a TileMap (ie wall/water/mud )
		elif target_obj is TileMapLayer:
# ICE
			if target_tile_data.get_custom_data("ice"):
				if inventory["SKATES"] < 1:
					if target_tile_data.get_custom_data("ice-dir").size() == 0:
						var target_tile2 = Vector2i(
							target_tile.x + int(dir.x),
							target_tile.y + int(dir.y),
						)
						var target_tile_data2 = walls.get_cell_tile_data(target_tile2)
						if target_tile_data2.get_custom_data("wall"):
							slide_animation(dir, dir * -1)
						else:
							slide_animation(dir, dir)
					else:
						var dir_from: Vector2 = current_tile - target_tile
						for i in target_tile_data.get_custom_data("ice-dir"):
							if i != dir_from:
								slide_animation(dir, i)
					return false
# WALL
			elif target_tile_data.get_custom_data("wall"):
					return false
# WATER
			elif target_tile_data.get_custom_data("water"):
				if inventory["FLIPPERS"] < 1:
					walls.set_cell(target_tile, 1, Vector2i(3,3))
					sprite.visible = false
					death.emit()
				else:
					swimming = true
# MUD
			elif target_tile_data.get_custom_data("mud"):
				# Change mud into flooring
				walls.set_cell(target_tile, 1, Vector2i(0,0))
# FIRE
			elif target_tile_data.get_custom_data("fire"):
				if inventory["FIRESHOES"] < 1:
					walls.set_cell(target_tile, 1, Vector2i(3,4))
					sprite.visible = false
					death.emit()
# FORCE
			elif target_tile_data.get_custom_data("force"):
				if inventory["SUCTION"] < 1:
					slide_animation(dir, target_tile_data.get_custom_data("force-dir"))
					return false
	else:
		swimming = false
		sliding = false
	
	return true	# Nothing in way

func slide_animation(dir: Vector2, next_tile: Vector2):
	sliding = true
	var new_pos = position + dir * size
	var tween = create_tween()
	tween.tween_property(self, "position", new_pos, 0.13)
	tween.tween_callback(move.bind(next_tile))

func toggle_look_ahead(enable: bool, target_obj: Object = null):
	if enable:
		raycast.add_exception(target_obj)
		raycast.target_position = raycast.target_position * 2
	else:
		raycast.clear_exceptions()
		raycast.target_position = raycast.target_position / 2
	raycast.force_raycast_update()

func _on_area_entered(area):
	if area is Enemy:
		death.emit()
