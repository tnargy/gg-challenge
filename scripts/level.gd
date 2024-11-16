class_name Level
extends Node2D

@export var level_number: int
@export var time_limit: int
@export var chips_needed: int

@onready var player = $Player
@onready var world = $".."

func _on_goal_complete():
	player.sprite.visible = false
	world.timer.start()
	get_tree().paused = true
