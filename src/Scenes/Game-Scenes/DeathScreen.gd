extends Node2D

export var anim_speed: int
var time = 0
var curr = 0
var letter = 0
var done = false
onready var labels = [
	get_node('DeathLabel'),
	get_node('TimeAlive'),
	get_node('WaveReached'),
	get_node('EnemiesKilled')
]
var msgs

func _ready() -> void:
	msgs = [
	'You died...',
	'Time alive: ' + str(Global.current_game_stats.get('time_alive')),
	'Wave reached: ' + str(Global.current_game_stats.get('current_wave')),
	'Enemies killed: ' + str(Global.current_game_stats.get('enemies_killed'))
	]
	Global.current_game_stats['time_alive'] = 0
	Global.current_game_stats['current_wave'] = 1
	Global.current_game_stats['enemies_killed'] = 0
	
func _physics_process(delta) -> void:
	if done:
		Transition.change_scene('res://Scenes/Game-Scenes/Menu.tscn')
	elif time % anim_speed == 0:
		print('next character')
		next_character()
	time += 1
	print(time)
		
func next_character() -> void:
	var text = msgs[curr].substr(0, letter)
	labels[curr].text = text
	print(len(text), " ", len(msgs[curr]))
	if len(text) == len(msgs[curr]):
		letter = 0
		if curr == 3:
			done = true
			return
		else:
			curr += 1
	else:
		letter += 1
