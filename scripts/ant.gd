class_name Ant
extends Node2D

@export var ant_speed: Timer
#@onready var path_2d: Path2D = $Path2D
#@onready var sprite: Sprite2D = $Path2D/Area2D/Sprite2D
@onready var path_follow_2d = $Path2D/PathFollow2D
var size = 32
var current_node = 0

func _ready():
	ant_speed.timeout.connect(_next_position)
	
func _next_position():
	path_follow_2d.progress += size
	#var next_node = current_node + 1
	#if next_node >= path_2d.curve.point_count:
		#next_node = 0
	#
	#var diff = path_2d.curve.get_point_position(next_node) - path_2d.curve.get_point_position(current_node)
	#diff /= size
	#position += diff * size * 2
	#
	#match diff:
		#Vector2.UP:
			#sprite.set_region_rect(Rect2(128,0*size,size,size))
		#Vector2.LEFT:
			#sprite.set_region_rect(Rect2(128,1*size,size,size))
		#Vector2.DOWN:
			#sprite.set_region_rect(Rect2(128,2*size,size,size))
		#_:
			#sprite.set_region_rect(Rect2(128,3*size,size,size))
	#
	#current_node += 1
