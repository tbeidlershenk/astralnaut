extends Node2D

var rng = RandomNumberGenerator.new()
var game_time = 0
var minutes_living = 0
var seconds_living = 0
var game_clock
var num_spawns = 0
var spawn_chance = 25
var start_level = 1
var enemy_count = 0

var spawns = [preload('res://Scenes/Entities/BasicEnemy.tscn'),
			 preload('res://Scenes/Entities/SummonerEnemy.tscn')]
					
var bounds = OS.get_window_size()
var bounds_x = [bounds[0]/2, -bounds[0]/2]
var bounds_y = [bounds[1]/2, -bounds[1]/2]

func _ready():
	rng.randomize()
	game_clock = self.get_node('Clock')
	$AnimatedSprite.animation = 'default'
	$AnimatedSprite.play()
	
func _physics_process(delta):
	if not get_node('Player').visible:
		Transition.change_scene('res://Scenes/Game-Scenes/Menu.tscn')
	if game_time % 60 == 0:
		update_clock()
		update_enemy_count()
	if num_spawns < 8 and game_time % 200 == 0:
		spawn_wave()
	if game_time % 300 == 0:
		spawn_chance = min(spawn_chance + 10, 100)
		start_level += 1
	game_time += 1

func spawn_wave():
	for key in Spawnpoints.points:
		if rng.randi_range(0,100) < spawn_chance:
			var mob = spawns[rng.randi_range(0,len(spawns)-1)].instance()
			mob.init(key, start_level)
			self.add_child(mob)
			
func update_enemy_count():
	num_spawns = 0
	for child in get_children():
		if 'Enemy' in child.name:
			num_spawns += 1
	
func update_clock():
	seconds_living += 1
	if seconds_living == 60:
		seconds_living = 0
		minutes_living += 1
	var text = 'Time alive: ' + str(minutes_living) + ':'
	if seconds_living < 10:
		text += '0'
	text += str(seconds_living)
	game_clock.text = text
	
