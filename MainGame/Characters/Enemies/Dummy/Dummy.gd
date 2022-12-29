extends BasicEnemy

var transformed = false

func _ready():
	EXP = 5
	base_health = 30
	base_armor = 20
	base_damage = 10
	base_regen = 0
	calculated_damage = base_damage
	damage = calculated_damage
	collision_mask = 9
	collision_layer = 0
	._ready()
	health_curr = calculated_health

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
