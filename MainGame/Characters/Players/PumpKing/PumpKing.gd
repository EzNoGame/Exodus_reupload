extends Player

func _ready():
	base_CD = 0.5
	self.attack_range = 'range'
	self.ulting_frame = 4
	self.basic_att_bullet = preload("res://MainGame/Bullets/PumpKingBullets/Basic/PumpKingBullet.tscn")
	self.ult_bullet = preload("res://MainGame/Bullets/PumpKingBullets/Ult/PumpKingHead.tscn")
	._ready()

func range_attack():
	.range_attack()
	SfxController.playSFX("res://sound effect/SFX/Gunshot Sound Effect.mp3")
