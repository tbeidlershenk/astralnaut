extends Node

# Preloads
var bullet = preload("res://Scenes/Projectiles/Bullet.tscn")
var missle = preload("res://Scenes/Projectiles/Missle.tscn")

onready var main = get_parent().get_parent()
onready var player = get_parent()
onready var ammobar = main.get_node('Ammobar')
onready var healthbar = main.get_node('Healthbar')

export var base_stats: Resource

# Base stats
var type
var max_health
var base_speed
var affect
var fire_rate
var missle_rate
var ammo
var max_ammo
var regen_ammo
var strafe_speed

# Other
var velocity = Vector2()
var has_died = false
var curr_health
var can_fire = 0
var can_missle = 0
var fire_mult = 1

# REMOVE THESE
var has_affect = 0
var affect_time = 180


func init():
	# Base
	type = base_stats.type
	max_health = base_stats.max_health
	base_speed = base_stats.base_speed
	affect = base_stats.affect
	fire_rate = base_stats.fire_rate
	missle_rate = base_stats.missle_rate
	max_ammo = base_stats.max_ammo
	ammo = base_stats.ammo
	regen_ammo = base_stats.regen_ammo
	strafe_speed = base_stats.strafe_speed
	# Other
	curr_health = max_health

func update_timers():
	can_fire = max(can_fire-1, 0)
	can_missle = max(can_missle-1, 0)
	has_affect = max(has_affect-1, 0)
	if has_affect == 0:
		remove_affect()
	ammo = min(ammo+regen_ammo, max_ammo)

func update_health(amount):
	if affect == null:
		pass
	elif affect.name == 'invincibility' and amount < 0:
		return
	curr_health = max(min(curr_health + amount, max_health), 0)
	player.get_node('AnimatedSprite').animation = 'damage'
	player.get_node('AnimatedSprite').play()
	yield(player.get_node('AnimatedSprite'), "animation_finished")
	if curr_health < max_health * 0.2:
		player.get_node('AnimatedSprite').animation = 'near_death'
		player.get_node('AnimatedSprite').play()
	else:
		player.get_node('AnimatedSprite').animation = 'default'
		player.get_node('AnimatedSprite').play()
		
	
func update_main():
	ammobar.value = ammo
	healthbar.value = curr_health

func handle_movement(right, left, up, down):
	velocity = Vector2()
	if up:
		velocity.y = -base_speed
	if down:
		velocity.y += base_speed
	if right:
		velocity.x = strafe_speed
	if left: 
		velocity.x -= strafe_speed

func handle_attack(reg, spec, use_item):
	if reg and can_fire <= 0 and ammo > 0:
		var b1 = bullet.instance()
		var b2 = bullet.instance()
		main.add_child(b1)
		main.add_child(b2)
		b1.init(get_parent(), get_parent().get_node('Gun1').get_global_position())
		b2.init(get_parent(), get_parent().get_node('Gun2').get_global_position())
		ammo -= 1
		can_fire = fire_rate
		player.get_node('MusicPlayer').play_stream(false, 'res://Assets/SFX/Gun_Pew.wav')
	if spec and can_missle <= 0:
		var mouse_pos = get_viewport().get_mouse_position()
		var mis = missle.instance()
		main.add_child(mis)
		mis.init(get_parent(), mouse_pos)
		can_missle = missle_rate
		player.get_node('MusicPlayer').play_stream(false, 'res://Assets/SFX/Gun_Pew.wav')
	if use_item and affect == null:
		player.get_node('MusicPlayer').play_stream(false, 'res://Assets/SFX/Selection_Confirm.wav')
		main.get_node('Items').most_recent_item()

func apply_affect(affect):
	self.affect = affect
	if affect == null or has_affect > 0:
		return
	if affect.name == 'heal':
		has_affect = 60
		update_health(affect.amount)
	elif affect.name == 'speed':
		has_affect = 60 * affect.duration
		print('fire rate increase')
		fire_rate /= affect.multiplier
		regen_ammo *= affect.multiplier
	elif affect.name == 'invincibility':
		has_affect = 60 * affect.duration

func remove_affect():
	if affect == null:
		return
	if affect.name == 'speed':
		fire_rate *= affect.multiplier
		regen_ammo /= affect.multiplier
	affect = null

func check_bounds():
	# check x
	if (player.position.x > Global.bounds[0]):
		player.position.x = Global.bounds[0]
	elif (player.position.x < Global.bounds[1]):
		player.position.x = Global.bounds[1]
	# check y
	if (player.position.y > Global.bounds[0]):
		player.position.y = Global.bounds[0]
	elif (player.position.y < Global.bounds[1]+200):
		player.position.y = Global.bounds[1]+200
