extends Node2D


export (PackedScene) var Digit:PackedScene
export (int) var digits:int
export (int) var value:int

var display := []

# Called when the node enters the scene tree for the first time.
func _ready():
	if digits < 1 || digits > 6:
		return
	
	for i in range(0, digits):
		display.append(Digit.instance())
		add_child(display[i])
		display[i].position.x = i * 16
	
	update_display(value)

func update_display(to_display:int) -> void:
	
	for i in range (digits-1, -1, -1):
		var num = to_display % 10
		to_display = round(to_display / 10)
		display[i].get_child(0).frame = num
