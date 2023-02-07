extends Node2D

onready var player = get_parent().get_node('Player')

var items = [
	'no_item',
	'no_item',
	'no_item'
	]
var slots = [
	'Slot1',
	'Slot2',
	'Slot3'
]

func add_item(new_item) -> void:
	for i in range(3):
		if items[i] == 'no_item':
			items[i] = new_item
			play_anim(i, false)
			return

func _on_item_click_input_event(viewport, event, shape_idx, slot) -> void:
	if !event.is_action_pressed('ui_select'):
		return
	else:
		var i = slots.find(slot)
		if items[i] == 'no_item':
			return
		player.stats.apply_affect(items[i])
		play_anim(i, true)
		items[i] = 'no_item'
		
func most_recent_item() -> void:
	for i in range(3):
		if items[2-i] != 'no_item':
			player.stats.apply_affect(items[2-i])
			play_anim(2-i, true)
			items[2-i] = 'no_item'
			return

func play_anim(slot, reversed) -> void:
	print(slot)
	var a = get_node(slots[slot]).get_node('AnimatedSprite')
	a.play(items[slot], reversed)
		
