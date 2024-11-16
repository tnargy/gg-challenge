extends Node2D

@onready var timer = $Timer
var level = 1

func _on_timer_timeout():
	#remove_child($Level)
	$Level.queue_free()
	level += 1
	var nextLevel = load("res://scenes/levels/level"+str(level)+".tscn")
	var l = nextLevel.instantiate()
	add_child(l)
	l.name = "Level"
	get_tree().paused = false
