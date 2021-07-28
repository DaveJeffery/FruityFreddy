extends Node2D

export (PackedScene) var Bonus:PackedScene
export (PackedScene) var Caterpillar:PackedScene
export (PackedScene) var Sparrow:PackedScene
export (PackedScene) var Dropping:PackedScene
export (PackedScene) var Fruit:PackedScene
export (PackedScene) var Bee:PackedScene
export (PackedScene) var DDT:PackedScene
export (PackedScene) var Meano:PackedScene
export (PackedScene) var FruitScore:PackedScene

var play_area := Vector2(608, 434)
var play_area_location := Vector2(32, 66)

var bee_area := Rect2(play_area_location, play_area)

var meano
var max_fruit := 10
var max_bees := 6
var max_time := 30
var level_time:int
var meano_out:bool

var ddt_position := Vector2(512,128)
var spray_time := 10
var spray_active := false

var sparrow
var caterpillar
var dropping
var ddt


var house_position = Vector2(56, 38)

var bonus_positions := [Vector2( 64,  80), 
						Vector2( 64, 480), 
						Vector2(584, 480), 
						Vector2(584,  80)]
var bonus = null

# Called when the node enters the scene tree for the first time.
func _ready():
	$Freddy.position = $FreddyStart.position
	randomize()
	spawn_fruit()
	spawn_meano()
	spawn_ddt()
	start_bonus_timer()
	start_caterpillar_timer()
	start_sparrow_timer()
	start_bee_timer()
	update_lives()
	update_level()
	update_score()
	update_hi()
	start_level_timer()

func spawn_fruit():
	for i in max_fruit:
		var fruit = Fruit.instance()
		fruit.init(false)
		fruit.connect("spawn", self, "_on_Fruit_spawn")
		$FruitContainer.add_child(fruit)
		fruit.position = calc_flower_location()

func spawn_meano():
	meano_out = false
	meano = Meano.instance()
	meano.position = $MeanoStart.position
	meano.house = $MeanoStart
	meano.fred = $Freddy
	$MeanoContainer.add_child(meano)

func spawn_ddt():
	ddt = DDT.instance()
	add_child(ddt)
	ddt.position = ddt_position

func update_score() -> void:
	$HUD.update_score(Global.current_score)

func update_lives() -> void:
	$HUD.update_lives(Global.current_lives)
	
func update_level() -> void:
	$HUD.update_level(Global.current_level)

func update_hi() -> void:
	$HUD.update_hi(Global.current_high)

func update_time() -> void:
	$HUD.update_time(level_time * 100)

func start_level_timer() -> void:
	level_time = max_time
	update_time()
	$LevelTimer.start()

func start_bonus_timer() -> void:
	$BonusTimer.wait_time = rand_range(3, 
									max(5, 10 - (Global.current_level * 0.5)))
	$BonusTimer.start()

func start_caterpillar_timer() -> void:
	$CaterpillarTimer.wait_time = rand_range(3, 10)
	$CaterpillarTimer.start()

func start_sparrow_timer() -> void:
	$SparrowTimer.wait_time = rand_range(3, 10)
	$SparrowTimer.start()

func start_spray_timer() -> void:
	$SprayTimer.wait_time = spray_time
	$SprayTimer.start()

func start_bee_timer() -> void:
	$BeeTimer.wait_time = rand_range(1, 5)
	$BeeTimer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
# func _process(delta):
#	 pass

func add_to_score(amount:int) -> void:
	Global.current_score += amount
	update_score()
	if Global.current_score > Global.current_high:
		Global.current_high = Global.current_score
		update_hi()

func _on_BonusTimer_timeout() -> void:
	if bonus != null and is_instance_valid(bonus):
		bonus.queue_free()
	else:
		bonus = Bonus.instance()
		bonus.level = Global.current_level
		bonus.position = bonus_positions[randi() % 3]	
		add_child(bonus)
	start_bonus_timer()

func remove_bonus() -> void:
	if bonus != null and is_instance_valid(bonus):
		bonus.queue_free()
		start_bonus_timer()

func _on_Freddy_bonus(_area) -> void:
	add_to_score(100 * (Global.current_level + 1))
	$BonusAudio.play()
	start_bonus_timer()

func _on_CaterpillarTimer_timeout():
	caterpillar = Caterpillar.instance()
	add_child(caterpillar)
	caterpillar.connect("tree_exited", self, "_on_Caterpillar_exit")

func _on_Caterpillar_exit():
	start_caterpillar_timer()

func _on_SparrowTimer_timeout():
	sparrow = Sparrow.instance()
	add_child(sparrow)
	sparrow.connect("tree_exited", self, "_on_Sparrow_exit")
	sparrow.connect("dropping", self, "_on_Sparrow_dropping", [], CONNECT_ONESHOT)
	
func _on_Sparrow_exit():
	start_sparrow_timer()

func _on_Sparrow_dropping(drop_position:Vector2):
	dropping = Dropping.instance()
	add_child(dropping)
	dropping.position = Vector2(drop_position)

func _on_LevelTimer_timeout():
	if level_time > 0:
		level_time -= 1
		update_time()
		if level_time < 10:
			$TickAudio.pitch_scale = 1.25 - (float(level_time) / 10)
			$TickAudio.play()
	else:
		lose_life()
		start_level_timer()

func _on_BeeTimer_timeout():
	if $BeeContainer.get_child_count() >= max_bees:
		return
	
	var bee = Bee.instance()
	$BeeContainer.add_child(bee)
	bee.init(bee_area, $BeeHive, $Freddy)

func clear_hazards() -> void:
	for bee in $BeeContainer.get_children():
		if bee != null and is_instance_valid(bee):
			bee.queue_free()
	if caterpillar != null and is_instance_valid(caterpillar):
		caterpillar.queue_free()
	if dropping != null and is_instance_valid(dropping):
		dropping.queue_free()
	if sparrow != null and is_instance_valid(sparrow):
		sparrow.queue_free()

func check_spray() -> void:
	if ddt != null and is_instance_valid(ddt):
		ddt.queue_free()
	spawn_ddt()
		

func bees_to_fred() -> void:
	for bee in $BeeContainer.get_children():
		if bee != null:
			bee.target_player()

func _on_Freddy_spray():
	start_spray_timer()
	spray_active = true
	$Freddy.set_spraying()
	$SprayAudio.play()

func _on_SprayTimer_timeout():
	spray_active = false
	$SprayAudio.stop()
	$Freddy.set_running()

func lose_life():
	if Global.current_lives >= 0:
		Global.current_lives -= 1

	if Global.current_lives > -1:
		update_lives()
	
	$SprayTimer.stop()
	spray_active = false
	$SprayAudio.stop()
	
	$Freddy.set_dying()
	$KillFredAudio.play()
	
	meano.home()
	meano_out = false

func _on_Freddy_hazard():
	lose_life()

func _on_Freddy_bee(area):
	if !spray_active:
		lose_life()
	else:
		area.kill_bee()
		$KillBeeAudio.play()
		add_to_score(100)

func _on_Freddy_reborn():
	if Global.current_lives == -1:
		Global.game_over()
	
	clear_hazards()
	check_spray()
	remove_bonus()
	$Freddy.position = $FreddyStart.position
	start_sparrow_timer()
	start_caterpillar_timer()

func _on_Freddy_fruit(area):
	if area.is_plant():
		if !meano_out:
			$MeanoAudio.play()
			meano_out = true
			meano.chase()
	else:
		var fruit_pos = area.position
		var fruit_mul = area.score()
		add_to_score(100 * fruit_mul)
		if fruit_mul == 1:
			$Fruit100Audio.play()
		if fruit_mul == 2:
			$Fruit200Audio.play()
		if fruit_mul == 3:
			$Fruit300Audio.play()
		area.pickup()
		var fruit_score = FruitScore.instance()
		$ScoreContainer.add_child(fruit_score)
		fruit_score.position = fruit_pos
		fruit_score.set_score(fruit_mul - 1)
		
		if $FruitContainer.get_child_count() <= 1:
			countdown_bonus()

func countdown_bonus() -> void:
	$Freddy.set_freeze()
	meano.home()
	meano_out = false
	
	while level_time > 0:
		level_time -= 1
		add_to_score(100)
		update_time()
		$TickAudio.play()
		yield(get_tree().create_timer(0.1), "timeout")
		update_score()
		
	Global.next_level()

func _on_Fruit_spawn(location):
	var spawn_locations:= [Vector2(-48,  24), Vector2( 48,  24),
						   Vector2(-48, -24), Vector2(-48, -24)]
	spawn_locations.shuffle()
	spawn_locations.resize((randi() % 4) + 1)
	
	for i in spawn_locations:
		if !is_valid_plant_position(location + i):
			continue
		var fruit = Fruit.instance()
		fruit.init(true, location, location + i)
		fruit.connect("spawn", self, "_on_Fruit_spawn")
		$FruitContainer.add_child(fruit)

func calc_flower_location() -> Vector2:
	var pos = Vector2.ZERO
	
	while !is_initial_plant_position(pos):
		pos.x = rand_range(play_area_location.x, play_area.x)
		pos.y = rand_range(play_area_location.y + 16, 
									 (play_area_location.y + play_area.y) - 32)
	return pos

# Checks the initial position of plants on a level is valid
func is_initial_plant_position(pos:Vector2) -> bool:
	var freddy_start = Rect2(16, 208, 80, 304)
	var bee_hive = Rect2(292, 448, 56, 48)
	
	if pos == Vector2.ZERO:
		return false
	if freddy_start.has_point(pos):
		return false
	if bee_hive.has_point(pos):
		return false
	return true

# Checks the seeded position of plants on a level is valid
func is_valid_plant_position(pos:Vector2) -> bool:
	if pos.x < play_area_location.x:
		return false
	if pos.x > play_area.x:
		return false
	if pos.y < play_area_location.y + 16:
		return false
	if pos.y > (play_area_location.y + play_area.y) - 32:
		return false
	return true
