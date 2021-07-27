extends Node2D

var Mode2Yellow = load("res://highscoreentry/Mode2Yellow.tscn")
var Mode2Magenta = load("res://highscoreentry/Mode2Magenta.tscn")

var chars := [["A", "B", "C", "D", "E", "F", "G", "H", "I"],
			  ["J", "K", "L", "M", "N", "O", "P", "Q", "R"],
			  ["S", "T", "U", "V", "W", "X", "Y", "Z", " "]]

var letter = Vector2(0, 0)
var entry := [null, null, null]

# Called when the node enters the scene tree for the first time.
func _ready():
	draw_letters()
	highlight_letter()
	update_entry()
	
func draw_letters() -> void:
	var frame: = 0
	
	for row in range(0, 3):
		for column in range(0, 9):
			var digit = Mode2Yellow.instance()
			$AlphabetContainer.add_child(digit)
			digit.position.x = 32 + (column * 64)
			digit.position.y = 160 + (row * 32)
			digit.get_child(0).frame = frame
			frame += 1

	for chr in range(0, 3):
		var digit = Mode2Magenta.instance()
		$InitialContainer.add_child(digit)
		digit.position.x = 256 + (chr * 32)
		digit.position.y = 336
		digit.get_child(0).frame = 27

func highlight_letter() -> void:
	var frame := 0
	
	for row in range(0, 3):
		for column in range(0, 9):
			var chr := (row * 9) + column
			
			if letter == Vector2(column, row):
				$AlphabetContainer.get_child(chr).get_child(0).frame = chr + 27
			else:
				$AlphabetContainer.get_child(chr).get_child(0).frame = chr
			frame += 1

func update_entry() -> void:
	for pos in range (0, 3):
		var chr = int(pos)
		if entry[pos] == null:
			$InitialContainer.get_child(chr).get_child(0).frame = 27
		else:
			var frame = (entry[pos].y * 9) + entry[pos].x
			$InitialContainer.get_child(chr).get_child(0).frame = frame

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var move := Vector2(0, 0)
	
	if Input.is_action_just_pressed("ui_right"):
		move += Vector2(1, 0)
	if Input.is_action_just_pressed("ui_left"):
		move += Vector2(-1, 0)
	if Input.is_action_just_pressed("ui_down"):
		move += Vector2(0, 1)
	if Input.is_action_just_pressed("ui_up"):
		move += Vector2(0, -1)
	if Input.is_action_just_pressed("ui_accept"):
		enter_letter()
		update_entry()
	
	if move.length() != 0:
		letter += move
		validate_letter()
		highlight_letter()

func validate_letter() -> void:
	letter.x = 8 if letter.x < 0 else int(letter.x) % 9
	letter.y = 2 if letter.y < 0 else int(letter.y) % 3

func enter_letter() -> void:
	var insert = entry.find(null)
	entry[insert] = letter
	if insert == 2:
		Global.name_entered(make_string())

func make_string() -> String:
	var name:String
	
	for chr in range (0, 3):
		var pos = entry[chr]
		name += chars[pos.y][pos.x]
	return name

func _on_FlashTimer_timeout():
	$NewHighScore.visible = !$NewHighScore.visible
