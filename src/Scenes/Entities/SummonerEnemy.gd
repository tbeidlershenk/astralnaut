extends RigidBody2D

var health = 100
var bounds = [-400, 400]
var speed = 100
var move = true
var damage = 0
var summon_rate = 300
var last_summon = 10
var direction = Vector2(-1, 0)
var obstacles_in_way = 0
var bomb = preload('res://Scenes/Entities/BomberEnemy.tscn')
onready var target = get_tree().get_root().get_node('Main').get_node('Player')
onready var sight = self.get_node('CollisionLine').get_node('CollisionShape2D')

func _ready():
	sight.shape.set_a(self.position)
	#target = get_tree().get_root().get_node('Player')
	sight.shape.set_b(target.position)

func _process(delta):
	last_summon += 1
	sight.shape.set_a(self.position)
	sight.shape.set_b(target.position)
	if last_summon <= 40:
		move = false
	else:
		move = true
	if obstacles_in_way == 0 and last_summon >= summon_rate:
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
	# Create two bomb nodes
	var b1 = bomb.instance()
	var b2 = bomb.instance()
	self.get_parent().add_child(b1)
	self.get_parent().add_child(b2)
	b1.init(self.get_node('Spawn1').get_global_position())
	b2.init(self.get_node('Spawn2').get_global_position())
	# Update variables
	last_summon = 0

func handle_collision(area):
	health = max(health-area.damage, 0)

func _on_Area2D2_area_entered(area):
	obstacles_in_way += 1

func _on_CollisionLine_area_exited(area):
	obstacles_in_way -= 1
