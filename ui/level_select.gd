extends GridContainer

@onready var levels: Array

func _ready():
	for child in get_children():
		child.disabled = true
		levels.append(child)
