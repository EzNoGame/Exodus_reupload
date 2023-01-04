extends Bullet

var life_span_fix

func _ready():	
	self.friendly = true
	self.floating = 0.3
	self.life_span = 20
	life_span_fix = life_span
	self.speed = 10
	self.speed_cap = 10
	._ready()

func _process(delta):
	modulate = Color(2,2,2,float(life_span)/float(life_span_fix))
