class_name BearTrap
extends Area2D

var target: Area2D

func _on_area_entered(area):
	area.stuck = true
	target = area
	

func _open_trap():
	if target:
		target.stuck = false
		target = null
