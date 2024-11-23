class_name BlueButton
extends Area2D

func _on_area_entered(area):
	if area is Player:
		for node in $"..".get_children():
			if node is Tank:
				node.move()
