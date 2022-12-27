extends BasicEnemy

var transformed = false

func _ready():
	EXP = 5
	calculated_damage = base_damage
	damage = calculated_damage
	base_health = 30
	base_armor = 20
	base_damage = 0
	._ready()

func update_animation():
	match state:
		attack:
			if able_to_attack:
				if state_machine.get_current_node() != 'walk_transform':
					state_machine.travel('walk_transform')
				state_machine.travel('attack')
				able_to_attack = false
			else:
				state_machine.travel('walk_transform')
		chase:
			state_machine.travel('transform')
			transformed = true
		scout:
			state_machine.travel('walk')
		
	.update_animation()	
