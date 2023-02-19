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
	if $AnimatedSprite.animation == 'death':
		self.queue_free()
		
func _on_Missle_area_entered(area):
	if Global.check_character(area) == '':
		return
	if "max_health" in area:
		damage = area.max_health
	if area.handle_collision(self):
		if 'Bomber' in area.name:
			return
		if curr_state != 'Exploding':
			curr_state = 'Exploding'
			velocity = Vector2()
			$AnimatedSprite.animation = 'death'
			$AnimatedSprite.play()
