class_name Teeth
extends Enemy

@export var walls: TileMapLayer
@export var player: Player
@onready var sprite: Sprite2D = $Sprite2D
@onready var raycast: RayCast2D = $RayCast2D

var size = 32
var current_direction
var speed = .5
var speed_delta = speed

func _ready():
	current_direction = update_direction()
	
		
func _physics_process(delta):
	if stuck: return
	raycast.target_position = player.position
	current_direction = update_direction()
	if raycast.is_colliding(): return
	speed_delta -= delta
	if speed_delta <= 0:
		speed_delta = speed
		position += current_direction * size


func update_direction() -> Vector2:
	var y_diff = player.position.y - position.y
	var x_diff = player.position.x - position.x
	
	if abs(y_diff) > abs(x_diff):
		if player.position.y > position.y:
			sprite.set_region_rect(Rect2(256,128,32,32))
			return Vector2.UP
		elif player.position.y < position.y:
			return Vector2.DOWN
			sprite.set_region_rect(Rect2(256,192,32,32))
	elif abs(y_diff) < abs(x_diff):
		if player.position.x > position.x:
			sprite.set_region_rect(Rect2(256,224,32,32))
			return Vector2.RIGHT
		elif player.position.x < position.x:
			sprite.set_region_rect(Rect2(256,160,32,32))
			return Vector2.LEFT
	else:
		if player.position.y > position.y:
			sprite.set_region_rect(Rect2(256,128,32,32))
			return Vector2.UP
		elif player.position.y < position.y:
			return Vector2.DOWN
			sprite.set_region_rect(Rect2(256,192,32,32))
		
		elif player.position.x > position.x:
			sprite.set_region_rect(Rect2(256,224,32,32))
			return Vector2.RIGHT
		elif player.position.x < position.x:
			sprite.set_region_rect(Rect2(256,160,32,32))
			return Vector2.LEFT
        else:
            return Vector2.ZERO
