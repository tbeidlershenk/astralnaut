extends Node

# Change scene and play transition
func change_scene(target_scene):
	$AnimationPlayer.play('Fade')
	yield($AnimationPlayer, "animation_finished")
	get_tree().change_scene(target_scene)
	$AnimationPlayer.play_backwards('Fade')
	
