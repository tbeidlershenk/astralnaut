extends Node2D

func _ready():
	Settings.load_settings()
	$AnimatedSprite.animation = 'default'
	$AnimatedSprite.play()

func _on_Play_button_down():
	$MusicPlayer.play_stream(false, 'res://Assets/SFX/Selection_Confirm.wav')
	Transition.change_scene('res://Scenes/Game-Scenes/Main.tscn')

func _on_Settings_button_down():
	$MusicPlayer.play_stream(false, 'res://Assets/SFX/Selection_Confirm.wav')
	Transition.change_scene('res://Scenes/Game-Scenes/SettingsScreen.tscn')

func _on_Menu_tree_entered():
	MusicPlayer.play_stream(true, 'res://Assets/SFX/menu-music.wav')

