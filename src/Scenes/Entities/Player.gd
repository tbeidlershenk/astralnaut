extends KinematicBody2D

var damage = 0
var has_died = false
var health = 2000
var velocity = Vector2()
var speed = 500
var strafe_speed = 300
var dir = 0
var gravity_vec = Vector2()
var bullet = preload("res://Scenes/Projectiles/Bullet.tscn")
var missle = preload("res://Scenes/Projectiles/Missle.tscn")
var can_fire = 0
var can_crash = 0
var missle_delay = 300
var can_fire_missle = 0
var crash_delay = 60
var fire_delay = 1
var ammo = 30000
var max_ammo = 60000
var ammo_cap = 2000
var ammo_regen = 2000

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
			
func _physics_process(delta):
	if has_died: return
	handle_input()
	check_pos()
	update_variables()
	update_game_components()
	velocity.x = move_and_slide(velocity+gravity_vec).x
	if health == 0: player_death()

func update_variables():
	can_crash = max(can_crash-1, 0)
	can_fire = max(can_fire-1, 0)
	can_fire_missle = max(can_fire_missle-1, 0)
	ammo = min(ammo+ammo_regen, max_ammo)
	
func update_game_components():
	var ammobar = self.get_parent().get_node('Ammobar')
	ammobar.value = ammo
	
func handle_input():
	handle_directional_input()
	handle_other_input()
		
func handle_directional_input():
	velocity = Vector2()
	var right = Input.is_action_pressed("ui_right")
	var left = Input.is_action_pressed("ui_left")
	var up = Input.is_action_pressed("ui_up")
	var down = Input.is_action_pressed("ui_down")
	
	# Directions
	if up:
		velocity.y = -speed
	if down:
		velocity.y += speed
	if right:
		velocity.x = strafe_speed
	if left: 
		velocity.x -= strafe_speed

func handle_other_input():
	
	var reg_attack = Input.is_action_pressed('ui_accept')
	var missle_attack = Input.is_action_pressed('ui_select')
	
	if reg_attack and can_fire <= 0 and ammo > max_ammo/ammo_cap:
		var b1 = bullet.instance()
		var b2 = bullet.instance()
		self.get_parent().add_child(b1)
		self.get_parent().add_child(b2)
		b1.init(self, self.get_node('Gun1').get_global_position())
		b2.init(self, self.get_node('Gun2').get_global_position())
		ammo -= max_ammo/ammo_cap
		can_fire = fire_delay
	elif missle_attack and can_fire_missle <= 0:
		var mouse_pos = get_viewport().get_mouse_position()
		var mis = missle.instance()
		self.get_parent().add_child(mis)
		mis.init(mouse_pos, self.position)
		can_fire_missle = missle_delay
	
func player_death():
	has_died = true
	var sprite = self.get_node('AnimatedSprite')
	sprite.animation = 'Death'
	sprite.play()
	print('You died')
			
func check_pos():
	var bounds_x = self.get_parent().bounds_x
	var bounds_y = self.get_parent().bounds_y
	# check x
	if (position.x > bounds_x[0]):
		position.x = bounds_x[0]
	elif (position.x < bounds_x[1]):
		position.x = bounds_x[1]
	# check y
	if (position.y > bounds_y[0]):
		position.y = bounds_y[0]
	elif (position.y < bounds_y[1]):
		position.y = bounds_y[1]
		
func handle_collision(body):
	health = max(health-body.damage, 0)
	var healthbar = self.get_parent().get_node('Healthbar')
	healthbar.value = health
	
func _on_Enemy_body_entered(body):
	handle_collision(body)
