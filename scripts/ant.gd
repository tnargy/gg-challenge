class_name Ant
extends Area2D

@export var speed: int = 100
@onready var path_follow= $".."


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	path_follow.progress += delta * speed
