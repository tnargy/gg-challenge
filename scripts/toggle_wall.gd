class_name ToggleWall
extends Area2D

@export var toggle: bool = true
@onready var closed = $Closed
@onready var open = $Open
@onready var collision_shape_2d = $CollisionShape2D

func _process(_delta):
	if toggle:
		$Closed.visible = true
		$Open.visible = false
	else:
		$Closed.visible = false
		$Open.visible = true
		
