extends BasicCharacter

class_name Player

var curr_coyote_time : int = 30
var max_coyote_time : int = 30
var jump_acc_counter = 0
var jump = false
var jump_frame_num = 10

var curr_facing = true

var base_CD = 5
var calculated_CD
var curr_shoot_CD = 5
var need_to_add_bullet = false
var need_to_burst = false
var basic_att_bullet
var ult_bullet
var bullet

var curr_ult_cd = 500
var max_ult_cd = 500
var ulting_frame = 5

var is_living = true

var score = 0
var dmg_offset = 0.1

var attack_range = ''

var chip_list = {
	num_red_chip = 0,
	num_green_chip = 0,
	num_blue_chip = 0
}

var _timer

var id

var EXP_to_next_level = 10
var level = 0

func _ready():

	self.h_acc = 90
	self.h_cap = 260
	self.g_acc = 40
	self.g_cap = 550
	self.j_acc = 100
	self.base_health = 100
	self.base_armor = 0
	self.friendly = true
	self.base_damage = 10
	self.creator = self
	self.EXP = 0
	calculated_CD = base_CD
	_timer = Timer.new()
	self.add_child(_timer)
	_timer.connect("timeout", self, "_on_Timer_timeout")
	_timer.set_wait_time(1.0)
	_timer.set_one_shot(false) # Make sure it loops
	_timer.start()
	._ready()


func update_velocity(delta):

	#horizonal movement

	#wak left
	if Input.is_action_pressed("left_player_%s" % [id]):
		if velocity.x > 30:
			velocity.x = 30
		facing_right = false
		curr_anim = "Walk"
		if velocity.x > -h_cap:
			velocity.x += h_acc*delta*(-h_cap-velocity.x)/h_cap*7.5

	#walk right		
	elif Input.is_action_pressed("right_player_%s" % [id]):
		if velocity.x < -30:
			velocity.x = -30
		facing_right = true
		curr_anim = "Walk"
		if velocity.x < h_cap:
			velocity.x += h_acc*delta*(h_cap-velocity.x)/h_cap*7.5

	#friction
	else:
		if abs(velocity.x) > 1:
			velocity.x = velocity.x*1/2
		else:
			velocity.x = 0


	#vertical movement

	#gravity
	if velocity.y < g_cap:	
		velocity.y += g_acc
	
	if is_on_floor():
		velocity.y = 5

	#climbing ladder
	if self.get_node("LadderBox").climb:
		collision_mask = 1
		curr_coyote_time = 0
		jump_acc_counter = 0
		velocity.y = 0
		if Input.is_action_pressed("up_player_%s" % [id]):
			velocity.y -= 200
		elif Input.is_action_pressed("down_player_%s" % [id]):
			velocity.y += 200
	else:
		collision_mask = 9
			
	#jump	
	if Input.is_action_just_pressed("jump_player_%s" % [id]) and curr_coyote_time < max_coyote_time:
		jump = true

	if Input.is_action_pressed("jump_player_%s" % [id]) and jump == true:
		if jump_acc_counter < jump_frame_num:
			if velocity.y > 0:
				velocity.y = 0
			velocity.y -= j_acc
			jump_acc_counter += 1
			
		if jump_acc_counter == jump_frame_num:
			jump = false

	if is_on_ceiling():
		velocity.y = 5
		jump = false

	if not is_on_floor() or self.get_node("LadderBox").climb:
		if curr_coyote_time < max_coyote_time:
			curr_coyote_time += 1
	else:
		curr_coyote_time = 0
		jump_acc_counter = 0


func range_attack():
	bullet = basic_att_bullet.instance()
	bullet.position = $ShootingPoint.get_global_position()
	bullet.direction = facing_right
	bullet.creator = self
	bullet.damage = calculated_damage
	need_to_add_bullet = true
	animation_player.play('Attack')

func melee_attack():
	print('attacking')
	curr_anim = 'Attack'
	animation_player.play(curr_anim)

func update_animation():
	
	if curr_facing != facing_right:	
		apply_scale(Vector2(-1,1))
		curr_facing = facing_right
		
	if abs(velocity.x) > 50 and is_on_floor():
		state_machine.travel('Walk')
		
	elif not is_on_floor() and velocity.y > 0:
		state_machine.travel('Fall_Down')
	
	elif not is_on_floor() and velocity.y < 0:
		state_machine.travel('Jump_Up')
	
	elif velocity.x < 50 and is_on_floor():
		state_machine.travel('Idle')

func ult():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	#level control
	if EXP >= EXP_to_next_level:
		EXP -= EXP_to_next_level
		level_up()
	
	#control attacking cd
	if curr_shoot_CD > 0:
		curr_shoot_CD -= 1
	
	#handling basic attack	
	if Input.is_action_pressed("attack_player_%s" % [id]) and curr_shoot_CD <= 0:
		if attack_range == 'range': 
			range_attack()
		elif attack_range == 'melee':
			melee_attack()
		curr_shoot_CD = calculated_CD
	
	#handling animation and velocity update	
	._process(delta)
	
	#handling ultimate
	ult()

func take_damage(dmg):
	.take_damage(dmg)
	state_machine.travel('Hurt')
	

func regen():
	if health_curr < calculated_health:
		health_curr += calculated_regen
	
func _process_stats():
	calculated_health = base_health*(1+0.1*chip_list['num_green_chip'])
	calculated_regen = base_regen*(1+0.3*chip_list['num_green_chip'])
	calculated_damage = base_damage*(1+0.1*chip_list['num_red_chip'])
	calculated_armor = chip_list['num_red_chip']*1.5
	calculated_CD = base_CD * (1*pow(0.98,chip_list['num_blue_chip']))
	#ult cd with data

func _on_Timer_timeout():
	_process_stats()
	regen()

func level_up():
	level += 1
	EXP_to_next_level = pow(level,2)*3 + 25
	var i = rng.randi_range(0,2)
	var keys = chip_list.keys()
	var key = keys[i]
	chip_list[key]+=1

	
