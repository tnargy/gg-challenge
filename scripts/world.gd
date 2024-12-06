class_name World
extends Node2D

@export var current_level: Level
@onready var timer = $Timer
var level: int
var max_level = 15


func _ready():
	level = load_furthest_level()
	if level > max_level: level = 1
	_loadLevel()

func _on_timer_timeout():
	if level < max_level:
		level += 1
		save_furthest_level()
		_loadLevel()
	else:
		print("Congrats you beat all the levels")
	
	
func _loadLevel():
	if current_level != null:
		current_level.queue_free()
	var nextLevel = load("res://scenes/levels/level"+str(level)+".tscn")
	if nextLevel == null:
		return
	var l = nextLevel.instantiate()
	add_child(l)
	current_level = l
	current_level.restart.connect(_loadLevel)
	current_level.hud.select_level_panel.visible = false
	get_tree().paused = false
	
func save_furthest_level():
	var file = FileAccess.open("user://level_data.json", FileAccess.READ_WRITE)
	if level > int(file.get_as_text()):
		file.store_string(str(level))
	file.close()

func load_furthest_level() -> int:
	var file = FileAccess.open("user://level_data.json", FileAccess.READ)
	var l: int = 1
	if file != null:
		l = int(file.get_as_text())
		file.close()
	return l
