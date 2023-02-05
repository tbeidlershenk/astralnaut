extends "res://Scenes/Projectiles/Projectile.gd"

var target

var states = {
	'Deploying': Vector2(0, -20),
	'Firing'   : Vector2(0, -2000),
	'Exploding': Vector2(0, 0)
	}

var curr_state = 'Deploying'

func _ready():
	._ready()
	damage = 100
	velocity = Vector2(0,30)
	
func init(src, target):
	.init(src, src.position + Vector2(0,75))
	self.target = target
	$AnimatedSprite.animation = 'default'
	$AnimatedSprite.play()
	
func _process(delta):
	._process(delta)
	update_missle(delta)
	
# Move missle based on state
func update_missle(delta):
	# Update
	if curr_state == 'Deploying' and self.velocity.y < 10:
		curr_state = 'Firing'
		
	velocity += states[curr_state] * delta
	self.position += velocity * delta
		
	# Check if miss
	if self.position.y > 1000:
		self.queue_free()
			
func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == 'Death':
		self.queue_free()

func _on_Missle_body_entered(body):
	if "max_health" in body:
		damage = body.max_health
	if body.handle_collision(self):
		curr_state = 'Exploding'
		velocity = Vector2()
		$AnimatedSprite.animation = 'Death'
		$AnimatedSprite.play()
		
