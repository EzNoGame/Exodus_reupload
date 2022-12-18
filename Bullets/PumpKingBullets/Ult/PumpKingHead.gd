extends Bullet

var i = 0

func _ready():
	self.life_span = 350
	self.speed = 10
	self.speed_cap = 20
	self.dmg = 10
	self.velocity.y = 20

func _process(delta):
	i=i+10
	self.transform.rotated(i)
