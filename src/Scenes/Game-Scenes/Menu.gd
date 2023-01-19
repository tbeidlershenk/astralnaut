extends Node2D

onready var anim = self.get_node("AnimatedSprite")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	anim.animation = 'default'
	anim.play()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Play_button_down():
	Transition.change_scene('res://Scenes/Game-Scenes/Main.tscn')

func _on_Settings_button_down():
	pass # Replace with function body.
