class_name World
extends Node2D

@export var current_level: Level
@onready var timer = $Timer
var level: int


func _ready():
	level = load_furthest_level()
	_loadLevel()

func _on_timer_timeout():
	level += 1
	save_furthest_level()
	_loadLevel()
	
	
func _loadLevel():
	if current_level != null:
		current_level.queue_free()
	if not ResourceLoader.exists("res://scenes/levels/level"+str(level)+".tscn"):
		print("Congrats you beat all the levels")
		return
	var nextLevel = load("res://scenes/levels/level"+str(level)+".tscn")
	var l = nextLevel.instantiate()
	add_child(l)
	current_level = l
	current_level.restart.connect(_loadLevel)
	current_level.hud.select_level_panel.visible = false
	get_tree().paused = false
	
func save_furthest_level():
	if not ResourceLoader.exists("res://scenes/levels/level"+str(level)+".tscn"):
		return
	var file = FileAccess.open("user://level_data.json", FileAccess.READ_WRITE)
	if file == null:
		file = FileAccess.open("user://level_data.json", FileAccess.WRITE)
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
