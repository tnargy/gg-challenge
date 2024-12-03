class_name BearTrapRelease
extends Area2D

@export var trap: BearTrap


func _on_area_entered(_area):
	trap.open_trap()
	print(_area)


func _on_area_exited(_area):
	trap.armed = true
