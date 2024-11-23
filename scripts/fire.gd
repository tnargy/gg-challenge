class_name Fire
extends Area2D


func _on_area_entered(area):
	if area is Player:
		if area.inventory["FIRESHOES"] < 1:
			$Sprite2D.set_region_rect(Rect2(96,128,32,32))
			area.sprite.visible = false
			area.death.emit()
