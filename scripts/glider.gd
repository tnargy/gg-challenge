class_name Glider
extends Enemy

@onready var raycast = $RayCast2D
@onready var walls: TileMapLayer = $"../Walls"

var current_direction
var speed = 100
var size = 32

func _ready():
	current_direction = raycast.target_position * 2 / size
		
func _physics_process(delta):
	if not raycast.is_colliding():
		position += current_direction * delta * speed
	else:
		checkDirection(raycast)
				

func new_rotate(new_rotation: int):
	var tween = create_tween()
	current_direction *= -1
	tween.tween_property(self, "rotation", new_rotation, 0.2)

func checkDirection(ray: RayCast2D):
	var target_obj = ray.get_collider()
	if target_obj is TileMapLayer:
		var target_tile = walls.local_to_map(target_obj.position)
		var target_tile_data = walls.get_cell_tile_data(target_tile)
		if target_obj is TileMapLayer:
			if target_tile_data.get_custom_data("wall"):
				return false
				