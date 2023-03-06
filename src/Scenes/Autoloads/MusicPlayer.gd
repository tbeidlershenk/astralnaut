extends AudioStreamPlayer

func play_stream(isMusic, path):
	if isMusic:
		self.volume_db = Global.music_level
	else:
		self.volume_db = Global.sfx_level
	self.set_stream(load(path))
	self.play()
