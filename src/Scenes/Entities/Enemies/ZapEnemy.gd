extends "res://Scenes/Entities/Enemies/Enemy.gd"

var can_fire
var parent = 'Enemy'
var damage
var vertical_move
var default_dir
var locations = [
	spawn_loc,
	Vector2(-250, 200),
	Vector2(0, 200),
	Vector2(250, 200)
]
var curr_pathfind = 0

func init_stats():
	.init_stats()
	damage = base_stats.damage
	
func _ready():
	init_stats()
	vertical_move = rng.randi_range(0,1) == 0
	default_dir = Vector2(1,0) if vertical_move else Vector2(0,1)
	direction = default_dir
	can_fire = fire_rate
	$ZapAnim.animation = 'default'
	$ZapAnim.play()

func _process(delta):
	if has_died: return
	can_fire = max(can_fire-1, 0)
	var diff = locations[curr_pathfind] - self.position
	direction = diff / diff.length()
	if abs(diff.length()) < 10:
		curr_pathfind = rng.randi_range(0,3)
	if !move:
		direction = Vector2()
	self.velocity = direction * base_speed
	self.position += self.velocity * delta

func fire():
	print('fire')
	$ZapAnim.animation = 'zap_warn'
	$ZapAnim.play()
	yield($ZapAnim, 'animation_finished')
	$ZapAnim.animation = 'zap_actual'
	$ZapAnim.play()
	yield($ZapAnim, 'animation_finished')
	$ZapAnim.animation = 'default'
	$ZapAnim.play()
	if !has_died: move = true

func _on_Diagonals_body_entered(body):
	if has_died: return
	if $ZapAnim.animation == 'default':
		move = false
		if can_fire == 0:
			can_fire = fire_rate
			fire()
	if $ZapAnim.animation == 'zap_actual':
		target.handle_collision(self)
