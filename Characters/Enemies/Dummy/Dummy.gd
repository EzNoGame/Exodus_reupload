extends BasicEnemy

var transformed = false

func _ready():
	EXP = 5
	base_damage = 10
	calculated_damage = base_damage
	damage = calculated_damage
	base_health = 30
	base_armor = 20
	base_damage = 10
	._ready()

func update_animation():
	.update_animation()
	if self.state == chase and not transformed:
		animation_player.play('transform')
		transformed = true
		
	if self.state == scout and transformed:
		animation_player.play_backwards('transform')
		transformed = false


