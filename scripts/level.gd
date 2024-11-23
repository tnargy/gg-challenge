class_name Level
extends Node2D

@export var level_number: int
@export var time_limit: int
@export var chips_needed: int

@onready var player = $Player
@onready var world = $".."
@onready var hud = $HUD

signal restart

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
