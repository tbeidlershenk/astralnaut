extends "res://Scenes/Entities/Character.gd"

var damage = 50
var target
var accel
var velocity = Vector2()
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
	
# can remove once all death animations are implemented
func handle_death():
	has_died = true
	$AnimatedSprite.animation = 'death'			# remove
	$AnimatedSprite.play()						# remove
	yield($AnimatedSprite, 'animation_finished')	# remove
	.handle_death()
	
func level_up():
	pass
		
func _on_BomberEnemy_body_entered(body):
	if body.handle_collision(self):
		curr_health = 0
		if !has_died:
			handle_death()
		
