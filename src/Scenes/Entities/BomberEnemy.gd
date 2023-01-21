extends Area2D

var damage = 50
var target
var accel
var velocity = Vector2()
var time_alive = 0
var lifespan = 300
var exploded = false
# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.animation = 'default'
	$AnimatedSprite.play()
	target = self.get_parent().get_node('Player')
	pass # Replace with function body.

func _process(delta):
	if exploded: 
		return
	if time_alive > lifespan:
		explode()
	pathfind(delta)
	time_alive += 1

func init(pos):
	self.position = pos
	self.velocity = Vector2(0,100)

func pathfind(delta):
	var dist = target.position - self.position
	var mag = target.position.distance_to(self.position)
	accel = (2000/mag) * dist
	velocity += accel * delta
	self.position += velocity * delta
	
func explode():
	exploded = true
	$AnimatedSprite.animation = 'death'
	$AnimatedSprite.play()
	yield($AnimatedSprite, 'animation_finished')
	print('removed')
	self.queue_free()
	
func _on_BomberEnemy_area_entered(area):
	var src = area.get_parent()
	if !exploded:
		explode()
	if 'Player' in src.name or 'Enemy' in src.name:
		src.handle_collision(self)
		
