extends Node2D

var rng = RandomNumberGenerator.new()
var game_time = 0
var minutes_living = 0
var seconds_living = 0
var game_clock
var difficulty = 5
var max_difficulty = 10
var spawns = [preload('res://Scenes/Entities/BasicEnemy.tscn'),
			 preload('res://Scenes/Entities/BomberEnemy.tscn')]
var spawn_locations = [Vector2(-300, -200),
					  Vector2(-100, -200),
					  Vector2(100, -200),
					  Vector2(300, -200)]
					
var bounds = OS.get_window_size()
var bounds_x = [bounds[0]/2, -bounds[0]/2]
var bounds_y = [bounds[1]/2, -bounds[1]/2]

func _ready():
	game_clock = self.get_node('Clock')
	
func _physics_process(delta):
	if game_time % 60 == 0:
		if difficulty > rng.randi_range(0, max_difficulty-1):
			print('adding enemy')
			var enemy = spawns[rng.randi_range(0, len(spawns)-1)].instance()
			self.add_child(enemy)
			enemy.position = spawn_locations[rng.randi_range(0, len(spawn_locations)-1)]
			if game_time % 600 == 0:
				difficulty = min(difficulty+1, max_difficulty)
				
		# Update game clock
		seconds_living += 1
		if seconds_living == 60:
			seconds_living = 0
			minutes_living += 1
		var text = 'Time alive: ' + str(minutes_living) + ':'
		if seconds_living < 10:
			text += '0'
		text += str(seconds_living)
		game_clock.text = text
			
	game_time += 1
