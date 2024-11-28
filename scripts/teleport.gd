class_name Teleport
extends Area2D

@export var Target: Teleport
signal teleport(old_pos: Vector2, new_pos: Vector2)


func _on_area_entered(area: Area2D) -> void:
	teleport.emit(area.position, Target.position)
