extends Node2D

onready var lives_display = $LivesDisplay
onready var bonus_display = $BonusDisplay
onready var score_display = $ScoreDisplay
onready var level_display = $LevelDisplay
onready var hi_display = $HiDisplay

func update_lives(lives:int) -> void:
	lives_display.update_display(lives)

func update_time(time:int) -> void:
	bonus_display.update_display(time)

func update_level(level:int) -> void:
	level_display.update_level(level)
	
func update_score(score:int) -> void:
	score_display.update_display(score)

func update_hi(high_score:int) -> void:
	hi_display.update_display(high_score)
