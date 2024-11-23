class_name World
extends Node2D

@export var current_level: Level
@onready var timer = $Timer
var level: int = 1
var max = 4

func _ready():
    load_furthest_level()
    if level > max: level = 1
    _loadLevel()

func _on_timer_timeout():
    if level < max:
        level += 1
        save_furthest_level()
        _loadLevel()
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
    get_tree().paused = false
    
func save_furthest_level():
    var file = FileAccess.open("user://level_data.json", FileAccess.WRITE)
    file.store_string(str(level))
    file.close()

func load_furthest_level():
    var file = FileAccess.open("user://level_data.json", FileAccess.READ)
    if file != null:
        level = int(file.get_as_text())
        file.close()
