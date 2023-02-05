extends "res://Scenes/Entities/Character.gd"

var obstacles_in_way = -2
var bomb = preload('res://Scenes/Entities/BomberEnemy.tscn')

onready var target = get_tree().get_root().get_node('Main').get_node('Player')
onready var sight = self.get_node('CollisionLine').get_node('CollisionShape2D')

func _ready():
	._ready()
	type = 'Enemy'
	curr_health = 100
	max_health = 100
	speed = 100
	direction = Vector2(-1, 0)
	fire_rate = 300
	
func _process(delta):
	._process(delta)
	last_fire += 1
	sight.shape.set_b(target.position-self.position)
	if last_fire <= 40:
		move = false
	else:
		move = true
	if last_fire >= fire_rate: #and obstacles_in_way == 0:
		summon()
		return
	elif self.position.x < bounds[0]:
		direction = Vector2(1,0)
	elif self.position.x > bounds[1]:
		direction = Vector2(-1,0)
	self.linear_velocity = direction * speed
	if !move:
		self.linear_velocity = Vector2()

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

# Collision line updates
func _on_Area2D2_area_entered(area):
	if not 'Bomber' in area.name:
		obstacles_in_way += 1

func _on_CollisionLine_area_exited(area):
	if not 'Bomber' in area.name:
		obstacles_in_way -= 1
