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
	var seconds = Global.time_alive % 60
	if seconds < 10:
		seconds = '0' + str(seconds)
	else:
		seconds = str(seconds)	
	msgs = [
	'You died...',
	'Time alive: ' + str(Global.time_alive/60) + ':' + seconds,
	'Wave reached: ' + str(Global.current_wave),
	'Enemies killed: ' + str(Global.enemies_killed),
	'Press r to play again\nPress space for main menu'
	]
	
func _physics_process(delta) -> void:
	if Input.is_action_pressed("ui_accept"):
		$MusicPlayer.play_stream(false, 'res://Assets/SFX/Selection_Confirm.wav')
		Transition.change_scene('res://Scenes/Game-Scenes/Menu.tscn')
	elif Input.is_action_pressed("ui_restart"):
		$MusicPlayer.play_stream(false, 'res://Assets/SFX/Selection_Confirm.wav')
		Transition.change_scene('res://Scenes/Game-Scenes/Main.tscn')
		MusicPlayer.play_stream(true, 'res://Assets/SFX/main_BGM.mp3')
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
