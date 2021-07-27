extends Area2D

signal bonus
signal spray
signal hazard
signal bee
signal reborn
signal fruit

enum {RUN, DIE, SPRAY, FREEZE}

# Declare member variables here. Examples:
var speed := 200 + (Global.current_level * 20)
var screen_size := Vector2(640,512)
var velocity:Vector2
var state := RUN

onready var fred:AnimatedSprite = ($AnimatedSprite as AnimatedSprite)
onready var spray:AnimatedSprite = ($AnimatedSprite2 as AnimatedSprite)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if state == DIE or state == FREEZE:
		return
		
	get_input()

	position += velocity * delta
	
	if state != SPRAY:
		position.x = clamp(position.x, 32, screen_size.x - 32)
	else:
		position.x = clamp(position.x, 64, screen_size.x - 64)
		
	position.y = clamp(position.y, 80, screen_size.y - 32)
	
	if velocity.x != 0:
		fred.flip_h = velocity.x < 0
		position_spray()
		
	if velocity.length() != 0:
		fred.playing = true
	else:
		fred.playing = false

func get_input() -> void:
	velocity = Vector2(0, 0)
	
	if Input.is_action_pressed("fred_right"):
		velocity += Vector2(1, 0)
	if Input.is_action_pressed("fred_left"):
		velocity += Vector2(-1, 0)
	if Input.is_action_pressed("fred_down"):
		velocity += Vector2(0, 1)
	if Input.is_action_pressed("fred_up"):
		velocity += Vector2(0, -1)
	
	if velocity.length() != 0:
		velocity = velocity.normalized() * speed

func set_spraying() -> void:
	state = SPRAY
	spray.visible = true
	position_spray()
	$FreddyCollision.set_deferred("disabled", true)
	$SprayCollision.set_deferred("disabled", false)

func position_spray() -> void:
	if fred.flip_h:
		$SprayCollision.position = Vector2(-32,0)
		spray.position = Vector2(-32, 0)
		spray.flip_h = true
	else:
		$SprayCollision.position = Vector2(32,0)
		spray.position = Vector2(32, 0)
		spray.flip_h = false


func set_running() -> void:
	if state == FREEZE:
		return
	
	state = RUN
	spray.visible = false
	$AnimatedSprite.animation = "walk"
	$AnimatedSprite.playing = false	
	$FreddyCollision.set_deferred("disabled", false)
	$SprayCollision.set_deferred("disabled", true)


func set_dying() -> void:
	state = DIE
	spray.visible = false
	$AnimatedSprite.animation = "cry"
	$AnimatedSprite.playing = true
	$FreddyCollision.set_deferred("disabled", true)
	$SprayCollision.set_deferred("disabled", true)
	$DieTimer.start()

func set_freeze() -> void:
	state = FREEZE
	$AnimatedSprite.playing = false	
	$FreddyCollision.set_deferred("disabled", true)
	$SprayCollision.set_deferred("disabled", true)

func _on_Freddy_area_entered(area:Area2D):
	if state == DIE or state == FREEZE:
		return
	
	if area.is_in_group("bonus"):
		area.pickup()
		emit_signal("bonus", area)
	if area.is_in_group("spray"):
		area.pickup()
		emit_signal("spray")
	if area.is_in_group("hazard"):
		emit_signal("hazard")
	if area.is_in_group("bee"):
		emit_signal("bee", area)
	if area.is_in_group("fruit"):
		emit_signal("fruit", area)

func _on_DieTimer_timeout():
	set_running()
	emit_signal("reborn")
