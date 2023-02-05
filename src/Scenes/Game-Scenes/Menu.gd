extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.animation = 'default'
	$AnimatedSprite.play()
	pass # Replace with function body.

func _on_Play_button_down():
	Transition.change_scene('res://Scenes/Game-Scenes/Main.tscn')

func _on_Settings_button_down():
	pass # Replace with function body.
