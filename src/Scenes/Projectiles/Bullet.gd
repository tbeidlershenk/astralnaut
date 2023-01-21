extends Area2D

var damage = 10
var bullet_speed
var remove_time = 200
var time_alive = 0
var velocity

func _ready():
	pass

# Call when instantiated
func init(src, pos):
	self.position = pos
	if 'Player' in src.name:
		bullet_speed = -700
	elif 'Enemy' in src.name:
		bullet_speed = 500
	velocity = Vector2(0, bullet_speed)

func _process(delta):
	if time_alive > remove_time:
		self.queue_free()
	else:
		time_alive += 1
		self.position = self.position + velocity*delta
		
# All objects collidable with bullets must implement handle_collision(Bullet)
func _on_Bullet_body_entered(body):
	if self.get_parent().name in body.name:
		return
	body.handle_collision(self)
	self.queue_free()
