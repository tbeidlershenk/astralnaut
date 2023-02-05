extends Node2D

var points = {
	Vector2(-300, -300) : 'P1',
	Vector2(-100, -300) : 'P2',
	Vector2(100, -300)  : 'P3',
	Vector2(300, -300)  : 'P4'
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func on_spawn(entity):
	var loc = entity.spawn_loc
	var anim = get_node(points.get(loc))
	anim.animation = 'spawn'
	anim.play()
	entity.move = false
	yield(anim, 'animation_finished')
	entity.visible = true
	entity.move = true
	reset(anim)
	
func reset(anim):
	anim.animation = 'default'
	anim.play()

func on_teleport():
	pass
