class_name Ant
extends Node2D

@onready var sprite: Sprite2D = $"../Sprite2D"
var size = 32
var speed = 100

func _process(delta):
	speed -= delta
	if speed <= 0:
		speed = 100
		move()


func move():
	match diff:
		Vector2.UP:
			sprite.set_region_rect(Rect2(128,0*size,size,size))
		Vector2.LEFT:
			sprite.set_region_rect(Rect2(128,1*size,size,size))
		Vector2.DOWN:
			sprite.set_region_rect(Rect2(128,2*size,size,size))
		_:
			sprite.set_region_rect(Rect2(128,3*size,size,size))