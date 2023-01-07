extends Node

var duration = 1.0

var target

var timer

export var type = 0
export var time_interval = 1.0

func _ready():
	if type == 0:
		timer = Timer.new()
		add_child(timer)

		timer.connect("timeout", self, "_on_timer_timeout")
		timer.set_wait_time(time_interval)
		timer.set_one_shot(false) # Make sure it loops
		timer.start()
		
	elif type == 1:
		return

func _process(delta):
	if type != 3:
		duration -= delta

func _on_timer_timeout():
	pass

func reset():
	pass
