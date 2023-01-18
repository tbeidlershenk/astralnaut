extends Node2D

var rng = RandomNumberGenerator.new()
var bounds = [-450, 450]
var spawn_locations
var my_spawn
var target
var move_toward_target = true
var states = [
	'Offensive',
	'Defensive',
	'Back'
	]
var curr_state = 'Offensive'
var direction

var health = 100
var has_died = false
var speed = 100
var follow_dist = 200
var time_since_crash = 0
var time_since_fire = 0
var fire_rate = 30
var bullet = preload("res://Scenes/Projectiles/Bullet.tscn")

func _ready():
	target = get_node('/root/Main/Player')
	spawn_locations = self.get_parent().spawn_locations
	my_spawn = self.position
	rng.randomize()
	
func _process(delta):
	#print(self.name + " " + self.curr_state)
	if target.position.y < self.position.y:
		curr_state = 'Back'
	else:
		if curr_state != 'Defensive':
			curr_state = 'Offensive'
	update_self()
	shoot_bullets()
	time_since_crash += 1
	if health <= 0:
		handle_death()

func update_self():
	if curr_state == 'Offensive':
		var diff = target.position.x - self.position.x
		# Already in-line
		if abs(diff) < 10:
			direction = Vector2()
		# If player to the right
		elif diff < 0:
			direction = Vector2(-1,0)
		# If player to the left
		else:
			direction = Vector2(1,0)
		self.linear_velocity = speed * direction
		if (target.position.y - self.position.y) > 300:
			self.linear_velocity += speed * Vector2(0,1)
	# Move back to spawn
	elif curr_state == 'Defensive':
		self.linear_velocity = speed * direction
		if (self.position - my_spawn).length() < 10:
			curr_state = 'Offensive'
	# Move back
	else:
		direction = Vector2(0,-1)
		
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
	if 'Bullet' in body.name:
		health = max(health-10, 0)
	elif 'Player' in body.name and time_since_crash > 60:
		health = max(health-40, 0)
	elif 'Missle' in body.name:
		health = 0
	time_since_crash = 0
	
func handle_death():
	has_died = true
	var sprite = self.get_node('AnimatedSprite')
	#sprite.animation = 'Death'
	#sprite.play()
	self.queue_free()

func _on_Area2D_area_entered(area):
	print('here')
	if 'Enemy' in area.get_parent().name:
		if self.position.y <= area.get_parent().position.y:
			curr_state = 'Defensive'
			var diff = my_spawn - self.position
			direction = diff / diff.length()
			

