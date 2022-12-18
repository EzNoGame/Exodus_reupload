extends BasicCharacter

var target_pos

var state
enum {
	scout,
	chase,
	attack
}

var target
var attack_target

var direction = -1
var horizontal_acc = 10
var horizontal_cap = 40
	
func _ready():
	health_max = 100
	armor = 100
	target = []
	attack_target = []
	friendly = false
	state = scout
	._ready()
	
func update_velocity(delta):
	velocity.y += 10
	if is_on_floor():
		velocity.y = 0
	match state:
		scout:
			if len(target) > 0:
				state = chase
				continue
			var i = rng.randi_range(0,100)
			if i < 3:
				direction = rng.randi_range(-1,1)
				continue
				
			else:
				velocity.x = direction*(abs(velocity.x)+horizontal_acc)
				if abs(velocity.x) > horizontal_cap :
					velocity.x = horizontal_cap * direction
			
		chase:
			if len(target) == 0:
				state = scout
				continue
				
			if len(attack_target) > 0:
				state = attack
				continue
				
			target_pos = target[0].get_global_position()
			
			if target_pos.x > self.position.x:
				direction = 1
			else:
				direction = -1
			
			velocity.x = direction*(abs(velocity.x)+horizontal_acc)
			if abs(velocity.x) > horizontal_cap :
				velocity.x = horizontal_cap * direction
		
		attack:
			velocity = Vector2(0,velocity.y)
			if len(attack_target) == 0:
				state = chase
				continue 
			attack()
	
func attack():
	pass
