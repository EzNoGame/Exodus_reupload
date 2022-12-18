extends Label

var time

func _ready():
	time = 0

func _process(delta):
	time += delta
