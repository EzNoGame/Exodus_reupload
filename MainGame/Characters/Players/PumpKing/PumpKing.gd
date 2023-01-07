extends Player

var damage_particle

func _ready():
	base_CD = 0.5
	self.attack_range = 'range'
	self.ulting_frame = 4
	self.damage_particle 
	
	self.basic_att_bullet = preload("res://MainGame/Bullets/PumpKingBullets/Basic/PumpKingBullet.tscn")
	self.ult_bullet = preload("res://MainGame/Bullets/PumpKingBullets/Ult/PumpKingHead.tscn")
	._ready()

func range_attack():
	.range_attack()
	SfxController.playSFX("res://sound effect/SFX/Gunshot Sound Effect.mp3")

func take_damage(target):
	.take_damage(target)
	damage_particle = load("res://MainGame/Characters/Players/PumpKing/DamageParticle.tscn").instance()
	damage_particle.emitting = true
	damage_particle.position = self.get_global_position()
	get_parent().get_parent().get_node("ParticleList").add_child(damage_particle)
	SfxController.playSFX("res://sound effect/SFX/Pumpking_Damaged.mp3")
