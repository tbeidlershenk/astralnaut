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
	get_node('EnemiesKilled'),
	get_node('HelperText')
]
var msgs

func _ready() -> void:
	msgs = [
	'You died...',
	'Time alive: ' + str(Global.time_alive/60) + ':' + str(Global.time_alive % 60),
	'Wave reached: ' + str(Global.current_wave),
	'Enemies killed: ' + str(Global.enemies_killed),
	'Press r to play again\nPress space for main menu'
	]
	#Global.current_game_stats['time_alive'] = 0
	#Global.current_game_stats['current_wave'] = 1
	#Global.current_game_stats['enemies_killed'] = 0
	
func _physics_process(delta) -> void:
	if Input.is_action_pressed("ui_accept"):
		Transition.change_scene('res://Scenes/Game-Scenes/Menu.tscn')
	elif Input.is_action_pressed("ui_restart"):
		Transition.change_scene('res://Scenes/Game-Scenes/Main.tscn')
	elif time % anim_speed == 0 and !done:
		next_character()
	time += 1
		
func next_character() -> void:
	var text = msgs[curr].substr(0, letter)
	labels[curr].text = text
	if len(text) == len(msgs[curr]):
		letter = 0
		if curr == len(msgs)-1:
			done = true
			return
		else:
			curr += 1
	else:
		letter += 1
