extends Node2D

# Preloads
var items = [
	preload('res://Resources/Items/heal.tres'),
	preload('res://Resources/Items/invincibility.tres'),
	preload('res://Resources/Items/speed.tres')
]

onready var player = get_parent().get_node('Player')

var curr_items = [null, null, null]
var slots = ['Slot1', 'Slot2', 'Slot3']

func add_item(num) -> void:
	for i in range(3):
		if curr_items[i] != null:
			continue
		else:
			curr_items[i] = items[num]
			play_anim(i, false)
			return

func _on_item_click_input_event(viewport, event, shape_idx, slot) -> void:
	if !event.is_action_pressed('ui_select'):
		return
	else:
		print(slot)
		var i = slots.find(slot)
		if curr_items[i] == null:
			return
		player.stats.apply_affect(curr_items[i])
		play_anim(i, true)
		curr_items[i] = null
		
func most_recent_item() -> void:
	for i in range(3):
		if curr_items[2-i] == null:
			continue
		else:
			player.stats.apply_affect(curr_items[2-i])
			print('Applied' + curr_items[2-i].name)
			play_anim(2-i, true)
			curr_items[2-i] = null
			return

func play_anim(i, reversed) -> void:
	var a = get_node(slots[i]).get_node('AnimatedSprite')
	a.play(curr_items[i].name, reversed)
		
