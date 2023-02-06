extends "res://Scenes/Entities/Character.gd"

var damage = 50
var target
var accel
var remove_time = 300
var parent = 'Enemy'

func _ready():
	# OVERRIDE
	type = 'Enemy'
	velocity = Vector2(0,100)
	$AnimatedSprite.animation = 'default'
	$AnimatedSprite.play()
	target = self.get_parent().get_node('Player')
	curr_health = 1
	
func _process(delta):
	if has_died: 
		return
	if time_alive > remove_time:
		handle_death()
	pathfind(delta)

func pathfind(delta):
	var dist = target.position - self.position
	var mag = target.position.distance_to(self.position)
	accel = (2000/mag) * dist
	velocity += accel * delta
	self.position += velocity * delta
	
	
# Override
func level_up():
	pass
		
func _on_BomberEnemy_area_entered(area) -> void:
	if GlobalFuncs.check_character(area) == 'Enemy':
		return
	curr_health = 0
	if !has_died:
		handle_death()
	else:
		if GlobalFuncs.check_character(area) != 'Player':
			return
		area.handle_collision(self)
