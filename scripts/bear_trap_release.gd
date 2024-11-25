class_name BearTrapRelease
extends Area2D

@export var trap: BearTrap


func _on_area_entered(_area):
	trap._open_trap()
