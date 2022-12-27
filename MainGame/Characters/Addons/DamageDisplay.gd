extends Node2D

var rng = RandomNumberGenerator.new()
var h_speed

func _ready():
	rng.randomize()
	h_speed = rng.randf_range(-1,1)

func _process(delta):
	self.position.x += h_speed 

func remove():
	queue_free()
