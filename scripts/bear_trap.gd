class_name BearTrap
extends Area2D

var target: Area2D
var armed: bool = true

func _on_area_entered(area):
	if target == null and armed:
		area.stuck = true
		target = area
		armed = false

func open_trap():
	if target:
		target.stuck = false
		target = null
	armed = false
