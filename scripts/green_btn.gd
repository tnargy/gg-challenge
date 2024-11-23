class_name GreenButton
extends Area2D

func _on_area_entered(area):
	if area is Player:
		for node in $"..".get_children():
			if node is ToggleWall:
				node.toggle = not node.toggle
