extends CanvasLayer

@export var level: Level

func _process(_delta):
	%Level.text = str(level.level_number)
	%Chips.text = str(level.chips_needed)


func _on_up_pressed():
	Input.action_press("Up")

func _on_left_pressed():
	Input.action_press("Left")

func _on_right_pressed():
	Input.action_press("Right")

func _on_down_pressed():
	Input.action_press("Down")
