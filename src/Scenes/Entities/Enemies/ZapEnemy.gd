extends "res://Scenes/Entities/Enemies/Enemy.gd"

var can_fire
var parent = 'Enemy'
var damage

func init_stats():
	.init_stats()
	damage = base_stats.damage
	
func _ready():
	init_stats()
	can_fire = fire_rate
	$ZapAnim.animation = 'default'
	$ZapAnim.play()

func _process(delta):
	can_fire = max(can_fire-1, 0)
	var dist = target.position - self.position
	if dist.x < dist.y:
		direction = Vector2(1,0)
	else:
		direction = Vector2(0,1)
	self.velocity = direction * base_speed
	self.position += self.velocity * delta


func fire():
	$ZapAnim.animation = 'fire'
	$ZapAnim.play()
	yield($ZapAnim, 'animation_finished')
	$ZapAnim.animation = 'default'
	$ZapAnim.play()
	move = true
	
func _on_Diagonals_area_entered(area):
	if Global.check_character(area.get_parent()) == 'Player':
		return
	elif can_fire == 0:
		can_fire = fire_rate
		move = false
		fire()
	elif $ZapAnim.animation == 'fire':
		target.handle_collision(self)

		
