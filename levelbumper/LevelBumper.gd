extends Node2D

var velocity = Vector2(1, 0)
var speed := 200

# Called when the node enters the scene tree for the first time.
func _ready():
	$FreddySprite.position = Vector2(16, 248)
	$LevelSprite.frame = 0
	$Num1.frame = 10
	$Num2.frame = 10

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$FreddySprite.position += velocity * speed * delta
	if $FreddySprite.position.x > 572:
		Global.begin_level()
	$LevelSprite.frame = ($FreddySprite.position.x - 180) / 32
	
	if $FreddySprite.position.x > 400:
		$Num2.frame = (Global.current_level + 1) % 10
	if $FreddySprite.position.x > 368:
		if (Global.current_level + 1) / 10 > 0:
			$Num1.frame = (Global.current_level + 1) / 10
