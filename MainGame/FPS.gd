extends Label

func _process(delta):
	self.text = "FPS: %s"%Engine.get_frames_per_second()
