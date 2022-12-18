extends Player

func _ready():
	self.health_max = 100
	self.attack_range = 'range'
	self.ulting_frame = 4
	self.basic_att_bullet = preload("res://Bullets/PumpKingBullets/Basic/PumpKingBullet.tscn")
	self.ult_bullet = preload("res://Bullets/PumpKingBullets/Ult/PumpKingHead.tscn")
	self.shoot_CD = 15
	._ready()
