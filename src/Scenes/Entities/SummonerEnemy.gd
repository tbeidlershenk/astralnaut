extends "res://Scenes/Entities/Character.gd"

var bomb = preload('res://Scenes/Entities/BomberEnemy.tscn')

onready var target = get_tree().get_root().get_node('Main').get_node('Player')

func _ready():
	._ready()
	type = 'Enemy'
	curr_health = 100
	max_health = 100
	speed = 100
	max_level = 5
	direction = Vector2(-1, 0)
	fire_rate = 1000
	
func _process(delta):
	._process(delta)
	if has_died:
		return
	last_fire += 1
	if last_fire <= 40:
		move = false
	else:
		move = true
	if last_fire >= fire_rate:
		summon()
		return
	elif self.position.x < bounds[0]:
		direction = Vector2(1,0)
	elif self.position.x > bounds[1]:
		direction = Vector2(-1,0)
	if !move:
		self.velocity = Vector2()

	self.velocity = direction * speed
	self.position += self.velocity * delta

func summon():
	# Play summon animation
	# ...
	# Create two bomb nodes
	var b1 = bomb.instance()
	var b2 = bomb.instance()
	self.get_parent().add_child(b1)
	self.get_parent().add_child(b2)
	b1.init(self.get_node('Spawn1').get_global_position(), 1)
	b2.init(self.get_node('Spawn2').get_global_position(), 1)
	# Update variables
	last_fire = 0
