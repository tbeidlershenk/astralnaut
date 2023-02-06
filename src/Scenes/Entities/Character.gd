extends Node2D

var rng = RandomNumberGenerator.new()
var spawn_locations = [
	Vector2(-300, -300),
	Vector2(-100, -300),
	Vector2(100, -300),
	Vector2(300, -300),
]
var bounds = [-400, 400]
var type = 'Character'
var spawn_loc = Vector2()
var speed = 100
var velocity = Vector2()
var direction = Vector2()
var max_health = 100
var curr_health = 100
var has_died = false
var fire_rate = 100
var last_fire = 0
var move = true
var level = 0
var max_level = 10
var time_alive = 1
var levelup_rate = 1000
var levelup_increase = 0.2

func _ready():
	rng.randomize()
	
func init(pos, level):
	self.position = pos
	spawn_loc = pos
	self.level = level
	var mult = pow((1+levelup_increase), level)
	fire_rate /= mult
	max_health *= mult
	curr_health = max_health
	$LevelBar.text = 'LVL ' + str(level)
		
	play_anim('spawn')
	
func _process(delta):
	if has_died:
		return
	if !move:
		self.velocity = Vector2()
	if curr_health <= 0:
		handle_death()
	if time_alive % levelup_rate == 0 and level < max_level:
		print(level)
		level_up()
	time_alive += 1
	
func level_up():
	level += 1
	fire_rate /= (1 + levelup_increase)
	max_health *= (1 + levelup_increase)
	curr_health = max_health
	
	$EnemyHealthbar.max_value = int(max_health)
	$EnemyHealthbar.value = int(max_health)
	$LevelBar.text = 'LVL ' + str(level)
	
	# Play level_up animation
	play_anim('level_up')
	
func handle_death():
	has_died = true
	play_anim('death')
	$EnemyHealthbar.visible = false
	$LevelBar.visible = false
	yield($AnimatedSprite, 'animation_finished')
	self.queue_free()
	
func play_anim(anim) -> void:
	$AnimatedSprite.animation = anim
	$AnimatedSprite.play()

func handle_collision(proj) -> bool:
	if proj.parent in type:
		return false
	else:
		curr_health = max(curr_health - proj.damage, 0)
		$EnemyHealthbar.value = int(curr_health)
		return true
	