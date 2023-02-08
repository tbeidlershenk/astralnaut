extends "res://Scenes/Entities/Enemies/Enemy.gd"

var bullet = preload("res://Scenes/Projectiles/Bullet.tscn")

var curr_state
var follow_dist
var retreat_dist

var states = [
	'Offensive',
	'Defensive',
	'Retreat'
	]
	
func _ready() -> void:
	init_stats()
		
func _process(delta):
	._process(delta)
	if has_died:
		return
	update_self(delta)
	shoot_bullets()

func init_stats():
	.init_stats()
	curr_state = base_stats.curr_state
	follow_dist = base_stats.follow_dist
	retreat_dist = base_stats.retreat_dist
	
func set_retreat():
	curr_state = 'Defensive'
	var diff = spawn_loc - self.position
	direction = diff / diff.length()
	
func update_self(delta):
	var dist = (target.position - self.position).length()
	if curr_state == 'Offensive':
		var diff = target.position.x - self.position.x
		if abs(diff) < 10:
			direction = Vector2()
		elif diff < 0:
			direction = Vector2(-1,0)
		else:
			direction = Vector2(1,0)
		if dist > follow_dist:
			direction += Vector2(0,1)
		elif dist < retreat_dist:
			set_retreat()
	
	# Move back to spawn
	else:
		if (self.position - spawn_loc).length() < 10:
			curr_state = 'Offensive'
	
	self.velocity = direction * base_speed
	self.position += self.velocity * delta
	
	# Teleport back	
	#var out_x = self.position.x < bounds[0] or self.position.x > bounds[1]
	#var out_y = self.position.y > bounds[1]
	#if out_x or out_y:
		#teleport()
	
func shoot_bullets():
	var in_range = abs(target.position.x - self.position.x) < 40
	if !(in_range and last_fire > fire_rate):
		last_fire += 1
		return
	var b1 = bullet.instance()
	var b2 = bullet.instance()
	self.get_parent().add_child(b1)
	self.get_parent().add_child(b2)
	b1.init(self, self.get_node('Gun1').get_global_position())
	b2.init(self, self.get_node('Gun2').get_global_position()) 
	last_fire = 0

# Retreat
func _on_SpaceArea_body_entered(body):
	if 'Enemy' in body.type:
		if self.position.y <= body.get_parent().position.y:
			set_retreat()

func _on_BasicEnemy_area_entered(area):
	if Global.check_character(area) == '':
		return
	if not 'Enemy' in area.type:
		return
	if self.position.y <= area.get_parent().position.y:
		set_retreat()
