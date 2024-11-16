@tool
class_name Door
extends Area2D

@export_enum("BLUE", "YELLOW", "GREEN", "RED", "GATE") var door_color: String
@onready var sprite_2d = $Sprite2D
var size = 32

func _ready():
	match door_color:
		"BLUE":
			sprite_2d.set_region_rect(Rect2(size,6*size,size,size))
		"RED":
			sprite_2d.set_region_rect(Rect2(size,7*size,size,size))
		"GREEN":
			sprite_2d.set_region_rect(Rect2(size,8*size,size,size))
		"YELLOW":
			sprite_2d.set_region_rect(Rect2(size,9*size,size,size))
		"GATE":
			sprite_2d.set_region_rect(Rect2(2*size,2*size,size,size))
