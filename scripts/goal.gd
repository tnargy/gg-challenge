class_name Goal
extends Area2D

@onready var sprite_2d = $Sprite2D
signal goal_complete

func _on_area_entered(_area):
	sprite_2d.set_region_rect(Rect2(96, 288,32,32))
	goal_complete.emit()
