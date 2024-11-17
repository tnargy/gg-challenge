extends Node2D

@export var current_level: Level
@onready var timer = $Timer
var level = 1

func _on_timer_timeout():
	current_level.queue_free()
	level += 1
	var nextLevel = load("res://scenes/levels/level"+str(level)+".tscn")
	if nextLevel == null:
		print("Congrats you beat all the levels")
		return
	var l = nextLevel.instantiate()
	add_child(l)
	current_level = l
	get_tree().paused = false
