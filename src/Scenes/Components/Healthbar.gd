extends ProgressBar

func _ready():
	self.max_value = self.get_parent().get_node('Player').health
	self.value = self.get_parent().get_node('Player').health
