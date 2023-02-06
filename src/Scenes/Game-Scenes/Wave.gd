extends Label

func _ready() -> void:
	self.text = 'Wave 0'

func update_text(curr_wave) -> void:
	self.text = 'Wave ' + str(curr_wave)
