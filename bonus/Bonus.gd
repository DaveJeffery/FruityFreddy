extends Area2D

export (int) var level:int

# Called when the node enters the scene tree for the first time.
func _ready():
	if level !=null:
		$Sprite.frame = level

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func pickup() -> void:
	queue_free()
