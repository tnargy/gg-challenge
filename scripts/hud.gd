extends CanvasLayer

@export var level: Level

func _process(_delta):
	%Level.text = str(level.level_number)
	%Chips.text = str(level.chips_needed)
