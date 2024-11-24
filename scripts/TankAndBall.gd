class_name TankAndBall
extends Enemy

@onready var raycast: RayCast2D = $RayCast2D
@onready var size = raycast.target_position.length()

var current_direction
var speed = .25
var speed_delta = speed

func _ready():
	var parent: Area2D = $"."
	raycast.target_position += raycast.target_position.angle_to(parent.rotation)
	current_direction = raycast.target_position / size

func move():
	var tween = create_tween()
	var new_rotation = deg_to_rad($Sprite2D.rotation_degrees + 180)
	raycast.target_position *= -1
	tween.tween_property($Sprite2D, "rotation", new_rotation, 0.2)
