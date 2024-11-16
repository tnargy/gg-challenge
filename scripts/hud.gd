extends CanvasLayer

@export var level: Level

const BLANK = preload("res://assets/blank.png")
const BLUEKEY = preload("res://assets/bluekey.png")
const REDKEY = preload("res://assets/redkey.png")
const YELLOWKEY = preload("res://assets/yellowkey.png")
const GREENKEY = preload("res://assets/greenkey.png")

func _process(_delta):
	%Level.text = str(level.level_number)
	%Chips.text = str(level.chips_needed)


func _on_player_inventory_changed(type: String, inv: int):
	match type:
		"BLUE":
			%BLUE.texture = BLUEKEY if inv > 0 else BLANK
		"RED":
			%RED.texture = REDKEY if inv > 0 else BLANK
		"YELLOW":
			%YELLOW.texture = YELLOWKEY if inv > 0 else BLANK
		"GREEN":
			%GREEN.texture = GREENKEY if inv > 0 else BLANK
