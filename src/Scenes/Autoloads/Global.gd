extends Node

var enemy = preload('res://Scenes/Entities/Enemies/Enemy.gd')
var player = preload('res://Scenes/Entities/Player/Player.gd')

export var difficulty = 1
export var music_level = 100
export var sfx_level = 100
var time_alive = 0
var current_wave = 1
var enemies_killed = 0
var bounds = [400, -400]

# Check if an Area2D is a character
func check_character(area) -> String:
	if area is enemy:
		return 'Enemy'
	elif area is player:
		return 'Player'
	else:
		return ''
		


