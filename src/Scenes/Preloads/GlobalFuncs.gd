extends Node

var enemy = preload('res://Scenes/Entities/Character.gd')
var player = preload('res://Scenes/Entities/Player.gd')

# Check if an Area2D is a character
func check_character(area) -> String:
	if area is enemy:
		return 'Enemy'
	elif area is player:
		return 'Player'
	else:
		return ''

