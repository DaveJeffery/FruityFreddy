extends Node

var high_score_table := 'res://highscore/HighScoreTable.tscn'
var high_score_entry := 'res://highscoreentry/HighScoreEntry.tscn'
var level_select := 'res://levelselect/LevelSelect.tscn'
var level_bumper := 'res://levelbumper/LevelBumper.tscn'
var level := 'res://levels/Level.tscn'

var current_score := 0
var current_level := 0
var current_high := 5000
var current_lives := 3

var high_scores := [[5000, "---"], 
					[5000, "---"],
					[5000, "---"],
					[5000, "---"],
					[5000, "---"],
					[5000, "---"],
					[5000, "---"],
					[5000, "---"],
					[5000, "---"]]

var score_list:String
var name_list:String

# Called when the node enters the scene tree for the first time.
func _ready():
	prepare_table()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_pressed("fred_quiet"):
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), true)
	if Input.is_action_pressed("fred_sound"):
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), false)

func start_game() -> void:
	current_score = 0
	current_lives = 3
	get_tree().change_scene(level_select)

func prepare_table() -> void:
	var score_array := []
	var name_array := []
	for entry in high_scores:
		score_array.append(entry[0])
		name_array.append(entry[1])
	score_list = "%06d\n".repeat(9) % score_array
	name_list = "%s\n".repeat(9) % name_array

func level_selected(selected_level:int) -> void:
	current_level = selected_level
	get_tree().change_scene(level_bumper)

func next_level() -> void:
	current_level += 1
	get_tree().change_scene(level_bumper)
	
func begin_level() -> void:
	get_tree().change_scene(level)

func game_over() -> void:
	# Check for high score
	var is_high_score:bool = false
	
	for score in range(0, 9):
		if current_score > high_scores[score][0]:
			is_high_score = true 
	
	if !is_high_score:
		get_tree().change_scene(high_score_table)
	else:
		get_tree().change_scene(high_score_entry)
	
func name_entered(name:String) -> void:
	var entry := 0
	
	while high_scores[entry][0] >= current_score:
		entry += 1
	
	high_scores.insert(entry, [current_score, name])
	high_scores.pop_back()
	prepare_table()
	get_tree().change_scene(high_score_table)
