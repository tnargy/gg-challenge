class_name World
extends Node2D

@export var current_level: Level
@onready var timer = $Timer
@onready var level: int = current_level.level_number

func _on_timer_timeout():
	level += 1
	_loadLevel()
	
	
func _loadLevel():
	current_level.queue_free()
	var nextLevel = load("res://scenes/levels/level"+str(level)+".tscn")
	if nextLevel == null:
		print("Congrats you beat all the levels")
		return
	var l = nextLevel.instantiate()
	add_child(l)
	current_level = l
	current_level.restart.connect(_loadLevel)
	get_tree().paused = false
	
