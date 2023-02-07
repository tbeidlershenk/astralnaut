extends ProgressBar

func _ready():
	self.max_value = self.get_parent().get_node('Player').get_node('Stats').max_ammo
	self.value = self.get_parent().get_node('Player').get_node('Stats').ammo
