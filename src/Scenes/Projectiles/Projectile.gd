extends Area2D

var time_alive = 0
var velocity
var damage
var parent

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func init(src, pos):
	parent = src.type
	self.position = pos
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time_alive += 1
