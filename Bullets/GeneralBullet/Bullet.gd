extends Node2D

class_name Bullet

export var life_span := 100
export var speed := 3
export var speed_cap := 10
export var floating := 0.1
var creator = ""
var direction = false
var velocity = Vector2()
var scored = false
export var friendly := true
export var damage := 10

func _ready():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	self.damage *= rng.randf_range(1-floating, 1+floating) 

func _process(delta):
	
	if abs(velocity.x) < speed_cap:
		if direction:
			velocity.x += speed
		else:
			velocity.x -= speed
			
	self.position += velocity
	
	life_span -= 1
	if life_span == 0:
		queue_free()
