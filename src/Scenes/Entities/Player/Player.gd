extends KinematicBody2D

onready var stats = $Stats

func _ready():
	$Stats.init()
			
func _physics_process(delta):
	if $Stats.has_died: 
		return
	elif $Stats.curr_health == 0: 
		player_death()
	handle_input()
	$Stats.check_bounds()
	$Stats.update_timers()
	$Stats.update_main()
	$Stats.velocity.x = move_and_slide($Stats.velocity).x
	
func handle_input():
	$Stats.handle_movement(
		Input.is_action_pressed("ui_right"),
		Input.is_action_pressed("ui_left"),
		Input.is_action_pressed("ui_up"),
		Input.is_action_pressed("ui_down")
	)
	$Stats.handle_attack(
		Input.is_action_pressed('ui_accept'),
		Input.is_action_pressed('ui_special_attack'),
		Input.is_action_pressed('ui_use_item')
	)
	
func player_death():
	$Stats.has_died = true
	$MusicPlayer.play_stream(false, 'res://Assets/SFX/Player_Hit3.wav')
	$AnimatedSprite.animation = 'Death'
	$AnimatedSprite.play()
	yield($AnimatedSprite, 'animation_finished')
	self.visible = false
	
func handle_collision(proj) -> bool:
	if proj.parent in $Stats.type:
		return false
	else:
		$Stats.update_health(-proj.damage)
		return true
