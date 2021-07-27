extends Area2D


# Declare member variables here. Examples:
var speed := 150 + (Global.current_level * 25)
var screen_size := Vector2(640,512)
var velocity := Vector2(0, 1)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += velocity * speed * delta
	
	if position.y > 512:
		queue_free()
