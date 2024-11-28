extends CanvasLayer

@export var level: Level
@onready var select_level_panel = $SelectLevelPanel
@onready var grid_container = $SelectLevelPanel/GridContainer
@onready var world = $World

const BLANK = preload("res://assets/blank.png")

func _ready():
	unlockLevels(level.level_number)

func _process(_delta):
	%Level.text = str(level.level_number)
	%Chips.text = str(level.chips_needed)

func _input(event):
	if event.is_action_pressed("LevelSelect"):
		var toggle = not $SelectLevelPanel.visible
		$SelectLevelPanel.visible = toggle
		get_tree().paused = toggle

func _on_player_inventory_changed(type: String, inv: int):
	match type:
		"BLUE":
			%BLUE.texture = preload("res://assets/keys/bluekey.png") if inv > 0 else BLANK
		"RED":
			%RED.texture = preload("res://assets/keys/redkey.png") if inv > 0 else BLANK
		"YELLOW":
			%YELLOW.texture = preload("res://assets/keys/yellowkey.png") if inv > 0 else BLANK
		"GREEN":
			%GREEN.texture = preload("res://assets/keys/greenkey.png") if inv > 0 else BLANK
		"FLIPPERS":
			%FLIPPERS.texture = preload("res://assets/shoes/flippers.png") if inv > 0 else BLANK
		"FIRESHOES":
			%FIRESHOES.texture = preload("res://assets/shoes/fireshoes.png") if inv > 0 else BLANK
		"SKATES":
			%SKATES.texture = preload("res://assets/shoes/skates.png") if inv > 0 else BLANK
		"SUCTION":
			%SUCTION.texture = preload("res://assets/shoes/suction.png") if inv > 0 else BLANK

func unlockLevels(l: int):
	var children = grid_container.levels
	for i in len(children):
		if i < l:
			children[i].disabled = false
			children[i].pressed.connect(loadLevel.bind(i+1))
			children[i].get_child(0).visible = false

func loadLevel(l: int):
	level.world.level = l
	level.world._loadLevel()
