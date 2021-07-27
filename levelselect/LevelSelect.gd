extends Node2D

var level:int

# Called when the node enters the scene tree for the first time.
func _ready():
	$Freddy.position = Vector2(224, 256)

func _on_Freddy_bonus(area:Area2D):
	$Freddy.set_freeze()
	level = area.level
	$BonusAudio.play()

func _on_BonusAudio_finished():
	Global.level_selected(level)
