extends "res://Scenes/Entities/Enemies/Enemy.gd"

var bomb = preload('res://Scenes/Entities/Enemies/BomberEnemy.tscn')

func _ready():
	._ready()
	direction = Vector2(1,0)
	
func _process(delta):
	._process(delta)
	if has_died:
		return
	last_fire += 1
	if last_fire >= fire_rate:
		summon()
	if self.position.x > Global.bounds[0] or self.position.x < Global.bounds[1]:
		direction = -direction

	self.velocity = direction * base_speed
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
