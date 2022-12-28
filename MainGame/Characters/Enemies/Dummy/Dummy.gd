extends BasicEnemy

var transformed = false

func _ready():
	EXP = 5
	calculated_damage = base_damage
	damage = calculated_damage
	base_health = 30
	base_armor = 20
	base_damage = 10
	collision_mask = 9
	collision_layer = 0
	._ready()

func update_animation():
	match state:
		attack:
			if able_to_attack:
				animation = 'attack'
				if state_machine.get_current_node() != 'walk_transform':
					animation = 'walk_transform'
				able_to_attack = false
			else:
				animation = 'walk_transform'
		chase:
			animation = 'walk_transform'
			transformed = true
		scout:
			animation = 'walk'
		
	.update_animation()	
