extends ProgressBar

onready var p = self.get_parent().get_node('Player')

func _ready():
	self.max_value = p.get_node('Stats').curr_health
	self.value = p.get_node('Stats').curr_health
