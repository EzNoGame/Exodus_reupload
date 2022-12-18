extends Player

func _ready():
	self.health_max = 100
	self.health = health_max
	self.attack_range = 'melee'
	self.acc = 20
	self.jump_acc = 130
	self.gravity = 70
	self.gravity_cap = 500
	self.horizontal_velocity_cap = 500
	self.ulting_frame = 4
	self.basic_att_bullet = preload("res://Scenes/MainGame/Bullets/PumpKing_bullet.tscn")
	self.ult_bullet = preload("res://Scenes/MainGame/Bullets/PumpKingHead.tscn")
	self.walking_dust = preload("res://Scenes/MainGame/particles/walking_dust.tscn").instance()

func ult():
	pass
