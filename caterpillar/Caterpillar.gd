extends Area2D

# Declare member variables here. Examples:
var speed := 150 + (Global.current_level * 25)
var screen_size := Vector2(640,512)
var velocity:Vector2
var y_pos:int

onready var caterpillar:AnimatedSprite = ($AnimatedSprite as AnimatedSprite)

# Called when the node enters the scene tree for the first time.
func _ready():	
	randomize()
	velocity = Vector2(1, 0) if randi() % 2  == 0 else Vector2(-1, 0)
	caterpillar.flip_h = velocity == Vector2(1, 0)
	
	y_pos = (randi() % 368) + 128
	
	if velocity == Vector2(1, 0):
		position = Vector2(0, y_pos)
	else:
		position = Vector2(640, y_pos)

	caterpillar.playing = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += velocity * speed * delta
	
	if position.x < 0 or position.x > 640:
		queue_free()
