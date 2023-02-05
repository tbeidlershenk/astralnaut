extends "res://Scenes/Projectiles/Projectile.gd"

var bullet_speed
var remove_time = 300

func _ready():
	._ready()
	damage = 10

# Call when instantiated
func init(src, pos):
	.init(src, pos)
	if 'Player' in parent:
		velocity = Vector2(0, -700)
	elif 'Enemy' in parent:
		velocity = Vector2(0, 500)

func _process(delta):
	._process(delta)
	if time_alive > remove_time:
		self.queue_free()
	else:
		self.position = self.position + velocity * delta
		
# All objects collidable with bullets must implement handle_collision(Bullet)
func _on_Bullet_body_entered(body):
	if body.handle_collision(self):
		self.queue_free()
