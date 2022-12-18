extends Bullet

func _ready():	
	self.friendly = true
	self.floating = 0.3
	self.life_span = 100
	self.speed = 10
	self.speed_cap = 10
	self.damage = 15
	._ready()
