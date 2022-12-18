extends BasicCharacter

class_name Player

var jump_acc : int = 195
var curr_coyote_time : int = 15
var max_coyote_time : int = 15
var jump_acc_counter = 0
var jump = false
var jump_frame_num = 10

var curr_facing = true

var shoot_CD = 5
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

var state_machine


func _ready():

	h_acc = 100
	h_cap = 350
	g_acc = 35
	g_cap = 650
	health_max = 100
	armor = 0
	friendly = true
	state_machine = $AnimationTree.get("parameters/playback")
	._ready()


func update_velocity(delta):

	#horizonal movement

	#wak left
	if Input.is_action_pressed("left_player_%s" % [id]) and not is_on_wall():
		if velocity.x > 30:
			velocity.x = 30
		facing_right = false
		curr_anim = "Walk"
		if velocity.x > -h_cap:
			velocity.x += h_acc*delta*(-h_cap-velocity.x)/h_cap*7.5

	#walk right		
	elif Input.is_action_pressed("right_player_%s" % [id]) and not is_on_wall():
		if velocity.x < -30:
			velocity.x = -30
		facing_right = true
		curr_anim = "Walk"
		if velocity.x < h_cap:
			velocity.x += h_acc*delta*(h_cap-velocity.x)/h_cap*7.5

	#friction
	else:
		velocity.x = velocity.x*49/60


	#vertical movement

	#gravity
	if velocity.y < g_cap:	
		velocity.y += g_acc

	if is_on_floor():
		velocity.y = 5

	#climbing ladder
	if self.get_node("LadderBox").climb:
		curr_coyote_time = 0
		jump_acc_counter = 0
		velocity.y = 0
		if Input.is_action_pressed("up_player_%s" % [id]):
			velocity.y -= 200
		elif Input.is_action_pressed("down_player_%s" % [id]):
			velocity.y += 200

	#jump	
	if Input.is_action_just_pressed("jump_player_%s" % [id]) and curr_coyote_time < max_coyote_time:
		jump = true

	if Input.is_action_pressed("jump_player_%s" % [id]) and jump == true:
		if jump_acc_counter < jump_frame_num:
			if velocity.y > 0:
				velocity.y = 0
			velocity.y -= (jump_acc - 55-(jump_frame_num-jump_acc_counter)*5)
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
	bullet.creator = name
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
	
	#control attacking cd
	if curr_shoot_CD > 0:
		curr_shoot_CD -= 1
	
	#handling basic attack	
	if Input.is_action_pressed("attack_player_%s" % [id]) and curr_shoot_CD == 0:
		if attack_range == 'range': 
			range_attack()
		elif attack_range == 'melee':
			melee_attack()
		curr_shoot_CD = shoot_CD
	
	#handling animation and velocity update	
	._process(delta)
	
	#handling ultimate
	ult()
