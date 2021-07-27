extends Area2D

enum{FRED, HOME}

# Declare member variables here. Examples:
var house:Node2D
var fred:Node2D
var target:Node2D
var state:int
var velocity:Vector2
var speed := 125 + (Global.current_level * 25)

# Called when the node enters the scene tree for the first time.
func _ready():
	home()

func chase() -> void:
	state = FRED
	target = fred

func home() -> void:
	state = HOME
	target = house

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity = Vector2(0, 0)
	
	if target.position.x > position.x:
		velocity += Vector2(1, 0)
	if target.position.x < position.x:
		velocity += Vector2(-1, 0)
	if target.position.y > position.y:
		velocity += Vector2(0, 1)
	if target.position.y < position.y:
		if state == HOME:
			if (position.y > 92 || position.x < 80):
				velocity += Vector2(0, -1)
		else:
			velocity += Vector2(0, -1)
	
	if velocity.length() != 0:
		velocity = velocity.normalized()
	
	position += velocity * speed * delta
