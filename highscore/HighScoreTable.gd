extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	$HighScores.text = Global.score_list
	$HighScoresNames.text = Global.name_list

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_pressed("ui_select"):
		Global.start_game()

func _on_FlashTimer_timeout():
	$SpaceBarLabel.visible = !$SpaceBarLabel.visible
