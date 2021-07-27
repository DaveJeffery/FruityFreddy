extends Area2D

enum {WANDER, HOME, DIE}

# Declare member variables here. Examples:
var hive:Node2D
var player:Node2D
var current_target:Node2D

var speed := 125 + (Global.current_level * 20)
var velocity:Vector2
var state:int
var play_area:Rect2

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.playing = true

func init(area:Rect2, bee_hive:Node2D, freddy:Node2D):
	play_area = area
	
	hive = bee_hive
	player = freddy

	position = hive.position
	current_target = player
	
	state = WANDER if randi() % 2 else HOME
	start_timer()

func target_player() -> void:
	current_target = player

func target_hive() -> void:
	current_target = hive

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if state == HOME:
		target_movement()
	if state == WANDER:
		if velocity == Vector2(0, 0):
			random_velocity()
	
	position += velocity * speed * delta
	
	if state != DIE:
		clamp_movement()
	else:
		check_fall()


func clamp_movement() -> void:
	if position.x < play_area.position.x:
		position.x = play_area.position.x + play_area.size.x
	if position.x > play_area.position.x + play_area.size.x:
		position.x = play_area.position.x
	if position.y < play_area.position.y:
		position.y = play_area.position.y + play_area.size.y
	if position.y > play_area.position.y+ play_area.size.y:
		position.y = play_area.position.y

func target_movement():
	velocity = Vector2(0, 0)
	
	if current_target.position.x > position.x:
		velocity += Vector2(1, 0)
	if current_target.position.x < position.x:
		velocity += Vector2(-1, 0)
	if current_target.position.y > position.y:
		velocity += Vector2(0, 1)
	if current_target.position.y < position.y:
		velocity += Vector2(0, -1)
	
	if velocity.length() != 0:
		velocity = velocity.normalized()
	
func random_velocity():
	var x_pos := rand_range(-1, 1) 
	var y_pos := rand_range(-1, 1) 
	
	velocity = Vector2(x_pos, y_pos).normalized()

func start_timer():
	if state == HOME:
		$BeeStateTimer.wait_time = rand_range(0.5, 2)
	else:
		$BeeStateTimer.wait_time = rand_range(2, 5)
	$BeeStateTimer.start()

func kill_bee() -> void:
	state = DIE
	velocity = Vector2(0, 1)
	speed = 200
	$AnimatedSprite.animation = "die"

func check_fall() -> void:
	if position.y > play_area.position.y+ play_area.size.y:
		queue_free()
		
func _on_BeeStateTimer_timeout():
	if state == DIE:
		return
	
	state = WANDER if state == HOME else HOME
	start_timer()
