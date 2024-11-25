class_name RedButton
extends Area2D

@export var clone: Clone


func _on_area_entered(_area):
	clone.createClone()
