extends Node2D

var rng = RandomNumberGenerator.new()
var game_time = 0
var minutes_living = 0
var seconds_living = 0
var num_spawns = 0
var spawn_chance = 25
var start_level = 1
var wave_delay = 5
var diff_delay = 20
var curr_wave = 0

var spawns = [
	preload('res://Scenes/Entities/Enemies/BasicEnemy.tscn'),
	preload('res://Scenes/Entities/Enemies/SummonerEnemy.tscn')
]

var points = [
	Vector2(-300, -300),
	Vector2(-100, -300),
	Vector2(100, -300),
	Vector2(300, -300)
]
					
var bounds = OS.get_window_size()
var bounds_x = [bounds[0]/2, -bounds[0]/2]
var bounds_y = [bounds[1]/2, -bounds[1]/2]

func _ready():
	rng.randomize()
	$AnimatedSprite.animation = 'default'
	$AnimatedSprite.play()
	
func _physics_process(delta):
	if not get_node('Player').visible:
		Transition.change_scene('res://Scenes/Game-Scenes/Menu.tscn')
	
	# Every second:
	if game_time % 60 == 0:
		#print($Items.curr_items)
		update_clock()
		# Every 5 seconds:
		if seconds_living % wave_delay == 0:
			spawn_wave()
			spawn_chance = min(spawn_chance + 5, 100)
			$Items.add_item(rng.randi_range(0,2))
		if seconds_living % diff_delay == 0:
			start_level += 1

			

	game_time += 1

func spawn_wave():
	var num_spawns = 0
	for key in points:
		if rng.randi_range(0,100) < spawn_chance:
			var mob = spawns[rng.randi_range(0,len(spawns)-1)].instance()
			self.add_child(mob)
			mob.init(key, start_level)
			num_spawns += 1
			
	if num_spawns == 0:
		var mob = spawns[rng.randi_range(0,len(spawns)-1)].instance()
		self.add_child(mob)
		mob.init(points[rng.randi_range(0, len(points)-1)], start_level)
		
	curr_wave += 1
	$Wave.text = 'Wave ' + str(curr_wave)
	
func spawn_powerup():
	pass

func update_clock():
	seconds_living += 1
	if seconds_living == 60:
		seconds_living = 0
		minutes_living += 1
	var text = 'Time alive: ' + str(minutes_living) + ':'
	if seconds_living < 10:
		text += '0'
	text += str(seconds_living)
	$Clock.text = text
	
