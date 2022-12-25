extends BasicCharacter

class_name BasicEnemy

var target_pos

var state
enum {
	scout,
	chase,
	attack
}

var target
var attack_target

var direction = 1
var prev_direction = 1
var horizontal_acc = 10
var horizontal_cap = 40

var _timer

var damage

func _ready():
	target = []
	attack_target = []
	friendly = false
	state = scout
	damage_floating = 0.1
	_timer = Timer.new()
	self.add_child(_timer)
	_timer.connect("timeout", self, "_on_Timer_timeout")
	_timer.set_wait_time(1.0)
	_timer.set_one_shot(false) # Make sure it loops
	._ready()
	_timer.start()
	
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
				
			#turn around if ray casting not on ground
			if not $Ground_Check.is_colliding():
				direction = -direction
				
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

func update_animation():
	if direction != prev_direction and direction != 0:
		prev_direction = direction
		self.scale.x = -self.scale.x
	
func attack():
	animation_player.play('attack')
	
func _on_Timer_timeout():
	damage = calculated_damage * rng.randf_range(1-damage_floating,1+damage_floating)

func death_handling(target):
	target.creator.EXP += EXP
	.death_handling(target)
