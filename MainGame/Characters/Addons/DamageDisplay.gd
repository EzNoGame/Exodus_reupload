extends Node2D

var h_speed

func _ready():
	h_speed = rand_range(-1,1)
	var val = float($LabelControl/Label.text)
	scale = Vector2(val/20+0.5, val/20+0.5)

func _process(delta):
	self.position.x += h_speed 

func remove():
	queue_free()
