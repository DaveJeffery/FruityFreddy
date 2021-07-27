extends Node2D

export (PackedScene) var Bonus:PackedScene
export (int) var level:int

var display := []

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(0, 10):
		display.append(Bonus.instance())
		add_child(display[i])
		display[i].position.x = i * 32
	
	update_level(level)

func update_level(_level:int) -> void:
	_level = _level % 10
	
	for i in range (0, 10):
		if i <= _level:
			display[i].get_child(0).frame = i
		else:
			display[i].get_child(0).frame = 9
