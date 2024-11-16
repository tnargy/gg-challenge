@tool
class_name Item
extends Area2D

@export_enum("CHIP", 
	"BLUE", "YELLOW", "GREEN", "RED",
) var item_type: String
var size = 32

@onready var sprite_2d = $Sprite2D
signal itemCollected(type: String)

func _ready():
	match item_type:
		"CHIP":
			sprite_2d.set_region_rect(Rect2(0,64,size,size))
		"BLUE":
			sprite_2d.set_region_rect(Rect2(192,4*size,size,size))
		"RED":
			sprite_2d.set_region_rect(Rect2(192,5*size,size,size))
		"GREEN":
			sprite_2d.set_region_rect(Rect2(192,6*size,size,size))
		"YELLOW":
			sprite_2d.set_region_rect(Rect2(192,7*size,size,size))

func _on_area_entered(area):
	if area.name == "Player":
		itemCollected.emit(item_type)
		queue_free()
