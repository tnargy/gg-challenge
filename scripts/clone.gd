class_name Clone
extends Area2D

@export var master: Enemy
@onready var scene: PackedScene = load(master.scene_file_path)

func _ready():
	master.stuck = true


func createClone():
	var clone: Enemy = scene.instantiate()
	var add_later = func():
		clone.walls = master.walls
		clone.start_vector = master.start_vector
		add_child(clone)
	add_later.call_deferred()
