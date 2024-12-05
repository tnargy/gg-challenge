class_name Level
extends Node2D

@export var level_name: String
@export var level_number: int
@export var time_limit: int
@export var chips_needed: int

@onready var player = $Player
@onready var world = $".."
@onready var hud = $HUD

var level_timer := Timer.new()
signal restart

func _ready():
	hud.visible = true
	hud.unlockLevels(world.load_furthest_level())
	if time_limit > 0:
		level_timer.wait_time = time_limit + 1
		level_timer.one_shot = true
		level_timer.autostart = time_limit > 0
		level_timer.connect("timeout", _restart_level)
		add_child(level_timer)


func _process(_delta):
	if level_timer.time_left > 0:
		time_limit = int(level_timer.time_left)


func _on_goal_complete():
	player.sprite.visible = false
	world.timer.start()
	get_tree().paused = true


func _on_player_death():
	var timer := Timer.new()
	timer.wait_time = 0.5
	timer.process_mode =Node.PROCESS_MODE_ALWAYS
	timer.one_shot = true
	timer.timeout.connect(_restart_level)
	add_child(timer)
	timer.start()
	get_tree().paused = true
	
func _restart_level():
	restart.emit()
