class_name Teleport
extends Area2D

@export var Target: Teleport


func _on_area_entered(area: Area2D) -> void:
	area.teleport(Target.position)
