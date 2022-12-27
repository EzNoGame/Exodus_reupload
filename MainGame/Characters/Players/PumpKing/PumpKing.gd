extends Player

func _ready():
	self.base_health = 100
	self.attack_range = 'range'
	self.ulting_frame = 4
	self.basic_att_bullet = preload("res://MainGame/Bullets/PumpKingBullets/Basic/PumpKingBullet.tscn")
	self.ult_bullet = preload("res://MainGame/Bullets/PumpKingBullets/Ult/PumpKingHead.tscn")
	self.base_CD = 15
	._ready()

func range_attack():
	.range_attack()
	$AttackSound.play()
