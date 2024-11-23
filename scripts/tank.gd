class_name Tank
extends Enemy

@export_enum("UP", "DOWN") var direction: String
@onready var raycast = $RayCast2D
var current_direction
var size = 100

func _ready():
	if direction == "UP":
		current_direction = Vector2.UP
	else:
		current_direction = Vector2.DOWN
		
func _physics_process(delta):
	if not raycast.is_colliding():
		position += current_direction * delta * size

func move():
	var tween = create_tween()
	var new_rotation = deg_to_rad(self.rotation_degrees + 180)
	current_direction *= -1
	tween.tween_property(self, "rotation", new_rotation, 0.2)
