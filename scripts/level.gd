class_name Level
extends Node2D

@export var level_number: int
@export var time_limit: int
@export var chips_needed: int

@onready var player = $Player

func _on_goal_complete():
	print("Congrats!")
	player.sprite.visible = false
	get_tree().paused = true
