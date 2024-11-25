class_name Clone
extends Area2D

@export var master: Enemy
@onready var scene: PackedScene = load(master.scene_file_path)

func _ready():
	master.stuck = true


func createClone():
	var clone: Enemy = scene.instantiate()
	add_child(clone)
	clone.start_vector = master.start_vector
	clone.walls = master.walls
	clone.raycast.target_position = clone.start_vector
	clone.size = clone.raycast.target_position.length()
