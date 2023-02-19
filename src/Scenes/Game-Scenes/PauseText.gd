extends Label

func _process(delta):
	if Input.is_action_just_pressed('ui_restart'):
		get_tree().paused = !get_tree().paused
		visible = !visible
