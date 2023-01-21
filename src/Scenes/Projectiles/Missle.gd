extends Area2D

var damage = 50
var target
onready var anim = self.get_node("AnimatedSprite")
var collidables = ['Player', 
				  'Basic']
var stages = {
	'Deploying': Vector2(0, -20),
	'Firing'   : Vector2(0, -2000),
	'Exploding': Vector2(0, 0)
	}

var curr = 'Deploying'
var velocity = Vector2(0,30)
var time_alive = 0

func init(target, player_loc):
	anim.animation = 'default'
	self.position = player_loc + Vector2(0,75)
	self.target = target
	anim.play()
	
func _process(delta):
	update_missle(delta)
	time_alive += 1
	
# Move missle based on stage
func update_missle(delta):
	# Update
	if curr == 'Deploying' and self.velocity.y < 10:
		curr = 'Firing'
		
	velocity += stages[curr] * delta
	self.position += velocity * delta
		
	# Check if miss
	if self.position.y > 1000:
		self.queue_free()

func _on_Missle_area_entered(area):
	for obj in collidables:
		if obj in area.name:
			area.get_parent().handle_collision(self)
			curr = 'Exploding'
			velocity = Vector2()
			anim.animation = 'Death'
			anim.play()
			
func _on_AnimatedSprite_animation_finished():
	if anim.animation == 'Death':
		self.queue_free()
