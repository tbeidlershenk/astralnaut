extends Control

onready var difficulty_buttons = get_node("VBoxContainer/Difficulty/DifficultyButtons").get_children()
onready var music_slider = get_node("VBoxContainer/Music/HScrollBar")
onready var sfx_slider = get_node("VBoxContainer/SFX/HScrollBar")

func _ready():
	Settings.load_settings()
	$AnimatedSprite.animation = 'default'
	$AnimatedSprite.play()
	var diff = int(Global.difficulty)
	var audio = int(Global.music_level)
	var sfx = int(Global.sfx_level)
	difficulty_buttons[diff-1].pressed = true
	music_slider.value = audio
	sfx_slider.value = sfx
	
	
func _on_difficulty_changed(name, diff):
	for button in difficulty_buttons:
		if name != button.name:
			button.pressed = false
		else:
			Global.difficulty = diff

func _on_audio_changed(value, source):
	if source == 'music':
		Global.music_level = value
	elif source == 'SFX':
		Global.sfx_level = value
		
func _input(event):
	if (event is InputEventKey):
		Transition.change_scene('res://Scenes/Game-Scenes/Menu.tscn')


func _on_SettingsScreen_tree_exiting():
	Settings.save_settings()
