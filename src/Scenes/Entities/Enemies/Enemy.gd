extends Node2D

export var base_stats: Resource

onready var target = get_tree().get_root().get_node('Main').get_node('Player')
var rng = RandomNumberGenerator.new()

# Base stats
var type
var base_speed
var max_health
var fire_rate
var level
var max_level
var levelup_rate
var levelup_increase

# Other stats
var has_died = false
var curr_health
var velocity = Vector2()
var direction = Vector2()
var spawn_loc = Vector2()
var last_fire = 0
var move = true
var time_alive = 1
var spawn_locations = [
	Vector2(-300, -300),
	Vector2(-100, -300),
	Vector2(100, -300),
	Vector2(300, -300),
]

func _ready():
	rng.randomize()
	init_stats()
	
func init_stats():
	type = base_stats.type
	base_speed = base_stats.base_speed
	max_health = base_stats.max_health
	fire_rate = base_stats.fire_rate
	level = base_stats.level
	max_level = base_stats.max_level
	levelup_rate = base_stats.levelup_rate * Global.difficulty
	levelup_increase = base_stats.levelup_increase * Global.difficulty
	curr_health = max_health
	
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
	if not 'Bomber' in name:
		Global.enemies_killed += 1
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
	
