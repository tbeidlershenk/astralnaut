extends Area2D

var anim
var target
var accel
var velocity = Vector2()
var time_alive = 0
var lifespan = 300
var exploded = false
# Called when the node enters the scene tree for the first time.
func _ready():
	anim = self.get_node("AnimatedSprite")
	anim.animation = 'default'
	anim.play()
	target = self.get_parent().get_node('Player')
	pass # Replace with function body.

func _process(delta):
	if exploded: 
		if !anim.is_playing():
			self.queue_free()
		return
	pathfind(delta)
	if time_alive > lifespan:
		explode()
	time_alive += 1
	
func pathfind(delta):
	var dist = target.position - self.position
	var mag = target.position.distance_to(self.position)
	accel = (2000/mag) * dist
	velocity += accel * delta
	self.position += velocity * delta
	
func explode():
	exploded = true
	anim.animation = 'Death'
	anim.play()
	
func _on_BomberEnemy_area_entered(area):
	if 'Player' in area.name:
		if !exploded:
			explode()
		else:
			target.handle_collision(self)
		
