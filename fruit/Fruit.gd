extends Area2D

enum {PLANT, FRUIT, SEED}
var state:int
var score_value:= [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 2, 2, 3]
var start:Vector2
var end:Vector2
var is_seed:bool

signal spawn

func _ready():
	if !is_seed:
		$AnimatedSprite.frame = randi() % 6
		set_plant()
	else:
		$AnimatedSprite.frame = 0
		set_seed()	

func init(_is_seed:bool,_start:Vector2 = Vector2(0, 0), 
		  _end:Vector2 = Vector2(0, 0)) -> void:
	is_seed = _is_seed
	start = _start
	end = _end

func set_plant() -> void:
	state = PLANT
	$Timer.wait_time = rand_range(0.0, 3.0)
	$FruitCollision.set_deferred("disabled", true)
	$PlantCollision.set_deferred("disabled", false)
	$Timer.start()

func set_seed() -> void:
	state = SEED
	$FruitCollision.set_deferred("disabled", true)
	$PlantCollision.set_deferred("disabled", true)
	$SeedTween.interpolate_property(self, "position", start, end, 0.3, 
									Tween.TRANS_SINE, Tween.EASE_OUT)
	$SeedTween.start()

func is_plant() -> bool:
	return state == PLANT

func score() -> int:
	return score_value[$AnimatedSprite.frame]

func pickup() -> void:
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if $AnimatedSprite.frame > 9:
		state = FRUIT
		$FruitCollision.set_deferred("disabled", false)
		$PlantCollision.set_deferred("disabled", true)

func _on_Timer_timeout():
	if $AnimatedSprite.frame < 14:
		$AnimatedSprite.frame += 1
		$Timer.wait_time = rand_range(0.0, max(2, 4.0 - (Global.current_level * .2)))
		$Timer.start()
	else:
		emit_signal("spawn", position)
		queue_free()

func _on_SeedTween_tween_completed(_object, _key):
	set_plant()
