extends Node2D

var damage = 0
var rng = RandomNumberGenerator.new()
var bounds = [-450, 450]
var spawn_locations
var my_spawn
var target
var move_toward_target = true
var states = [
	'Offensive',
	'Defensive',
	'Retreat'
	]
var curr_state = 'Offensive'
var direction

var health = 100
var has_died = false
var speed = 100
var follow_dist = 400
var retreat_dist = 200
var time_since_fire = 0
var fire_rate = 30
var bullet = preload("res://Scenes/Projectiles/Bullet.tscn")
var just_collided = false

func _ready():
	target = get_node('/root/Main/Player')
	spawn_locations = self.get_parent().spawn_locations
	rng.randomize()
	
func init():
	my_spawn = self.position
	
func _process(delta):
	#print(self.name + " " + self.curr_state)
	update_self()
	shoot_bullets()
	if health <= 0:
		handle_death()

func update_self():
	if just_collided:
		curr_state = 'Defensive'
		just_collided = false
	var dist = (target.position - self.position).length()
	if curr_state == 'Offensive':
		var diff = target.position.x - self.position.x
		if abs(diff) < 10:
			direction = Vector2()
		elif diff < 0:
			direction = Vector2(-1,0)
		else:
			direction = Vector2(1,0)
		self.linear_velocity = speed * direction
		if dist > follow_dist:
			direction += Vector2(0,1)
		elif dist < retreat_dist:
			curr_state = 'Retreat'
			direction = Vector2(0,-1)
	
	# Move back to spawn
	elif curr_state == 'Defensive':
		if (self.position - my_spawn).length() < 10:
			curr_state = 'Offensive'
	
	# Move back
	elif curr_state == 'Retreat':
		if dist > follow_dist:
			curr_state = 'Offensive'
	
	# Update velocity
	self.linear_velocity = speed * direction
		
	# Teleport back	
	var out_x = self.position.x < bounds[0] or self.position.x > bounds[1]
	var out_y = self.position.y > bounds[1]
	if out_x or out_y:
		self.position = spawn_locations[rng.randi_range(0,3)]
	
func shoot_bullets():
	var in_range = abs(target.position.x - self.position.x) < 40
	if !(in_range and time_since_fire > fire_rate):
		time_since_fire += 1
		return
	var b1 = bullet.instance()
	var b2 = bullet.instance()	
	self.get_parent().add_child(b1)
	self.get_parent().add_child(b2)
	b1.init(self, self.get_node('Gun1').get_global_position())
	b2.init(self, self.get_node('Gun2').get_global_position())
	time_since_fire = 0
	
func handle_collision(body):
	health = max(health-body.damage, 0)
	
func handle_death():
	has_died = true
	var sprite = self.get_node('AnimatedSprite')
	#sprite.animation = 'death'
	#sprite.play()
	self.queue_free()

func _on_Area2D_area_entered(area):
	print('here')
	if 'Enemy' in area.get_parent().name:
		if self.position.y <= area.get_parent().position.y:
			var diff = my_spawn - self.position
			direction = diff / diff.length()
			just_collided = true
			

