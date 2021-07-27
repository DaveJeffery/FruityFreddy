extends Area2D

signal dropping

# Declare member variables here. Examples:
var speed := 150 + (Global.current_level * 25)
var screen_size := Vector2(640, 512)
var velocity:Vector2
var y_pos:int
var dropping_pos:int

onready var sparrow:AnimatedSprite = ($AnimatedSprite as AnimatedSprite)

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	velocity = Vector2(1, 0) if randi() % 2  == 0 else Vector2(-1, 0)
	sparrow.flip_h = velocity == Vector2(-1, 0)
	
	dropping_pos = randi() % int(screen_size.x)
	
	y_pos = 80
	
	if velocity == Vector2(1, 0):
		position = Vector2(0, y_pos)
	else:
		position = Vector2(640, y_pos)
	
	sparrow.playing = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += velocity * speed * delta
	
	if position.x < 0 or position.x > 640:
		queue_free()
	
	if velocity == Vector2(1, 0):
		if position.x > dropping_pos:
			emit_signal("dropping", Vector2(dropping_pos, y_pos))
	else:
		if position.x < dropping_pos:
			emit_signal("dropping", Vector2(dropping_pos, y_pos))
