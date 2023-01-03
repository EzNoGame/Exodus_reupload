extends BasicCharacter

class_name Player

var base_h_acc
var base_h_cap
var calculated_h_acc
var calculated_h_cap

var curr_coyote_time : int = 30
var max_coyote_time : int = 30
var jump_acc_counter = 0
var jump = false
var jump_frame_num = 10

var curr_facing = true

var base_CD = 100
var calculated_CD
var curr_shoot_CD = 0
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

var _timer

var id

var EXP_to_next_level

var freeze = false

var PlayerData = {
	'AddonsInInventory':[],
	'AddonsEquiped' : [],
	'EXP' : 0,
	'Level' : 0,
	'Num_of_Green' : 0,
	'Num_of_Red' : 0,
	'Num_of_Blue' : 0,
	'Health' : 100
}

func _ready():
	self.EXP_to_next_level = 10
	self.base_h_acc = 1
	self.base_h_cap = 150
	self.calculated_h_acc = base_h_acc
	self.calculated_h_cap = base_h_cap
	self.g_acc = 12
	self.g_cap = 250
	self.j_acc = 40
	self.friendly = true
	self.creator = self
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
		if velocity.x > -calculated_h_cap:
			velocity.x += calculated_h_acc*delta*(-calculated_h_cap-velocity.x)/calculated_h_cap*7.5

	#walk right		
	elif Input.is_action_pressed("right_player_%s" % [id]):
		if velocity.x < -30:
			velocity.x = -30
		facing_right = true
		curr_anim = "Walk"
		if velocity.x < calculated_h_cap:
			velocity.x += calculated_h_acc*delta*(calculated_h_cap-velocity.x)/calculated_h_cap*7.5
	
	#friction
	else:
		if abs(velocity.x) > 1:
			velocity.x = velocity.x*1/2
		else:
			velocity.x = 0
	
	if abs(velocity.x) > calculated_h_cap:
		velocity.x = calculated_h_cap*(velocity.x/abs(velocity.x))

	#vertical movement

	#gravity
	if velocity.y < g_cap:	
		velocity.y += g_acc*delta
	
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
			velocity.y -= j_acc*delta
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
		
	if abs(velocity.x) > 10 and is_on_floor():
		animation = 'Walk'
		
	elif not is_on_floor() and velocity.y > 0:
		animation = 'Fall_Down'
	
	elif not is_on_floor() and velocity.y < 0:
		animation = 'Jump_Up'
	
	elif velocity.x < 50 and is_on_floor():
		animation = 'Idle'
		
	if state_machine.get_current_node() != animation:
		state_machine.travel(animation)

func ult():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	#level control
	if EXP >= EXP_to_next_level:
		EXP -= EXP_to_next_level
		level_up()
	
	#control attacking cd
	if curr_shoot_CD > 0:
		curr_shoot_CD -= 1*delta
	
	#handling basic attack	
	if Input.is_action_pressed("attack_player_%s" % [id]) and curr_shoot_CD <= 0:
		if attack_range == 'range': 
			range_attack()
		elif attack_range == 'melee':
			melee_attack()
		curr_shoot_CD = calculated_CD
	
	#handling animation and velocity update	
	._physics_process(delta)
	#handling ultimate
	ult()

func _process(delta):
	if Input.is_action_just_pressed("Addons_player_%s"%[id]):
		if not freeze:
			var data
			var file = File.new()
			if file.open("Data/Run.json", File.READ) == OK:
				file.open("Data/Run.json", File.READ)
				var json = JSON.parse(file.get_as_text())
				file.close()
				data = json.result
			else:
				print("json file invalid")
				
			PlayerData['Health'] = health_curr
			data['PlayersData']["Player%s"%[id]] = PlayerData
				
			file.open("Data/Run.json",File.WRITE)
			file.store_line(to_json(data))
			file.close()
			toggle_script_off()
			freeze = true
			
		else:
			toggle_script_on()
			freeze = false
			yield(get_tree(), "idle_frame")
			var file = File.new()
			if file.open('Data/Run.json', File.READ) == OK:
				file.open('Data/Run.json', File.READ)
				var json = JSON.parse(file.get_as_text())
				file.close()
				var data = json.result
				PlayerData = data['PlayersData']["Player%s"%[id]] 

func take_damage(dmg):
	.take_damage(dmg)
	state_machine.start('Hurt')
	
func death_handling():
	Transition.change_scene("res://Menu/Menus/settlement.tscn")
	
func regen():
	if health_curr < calculated_health:
		health_curr += calculated_regen
	
func _process_stats():
	
	apply_modify()
	
	calculated_h_acc = calculated_h_acc * (1+0.05*(PlayerData['Num_of_Blue']))
	calculated_h_cap= calculated_h_cap * (1+0.05*(PlayerData['Num_of_Blue']))
	calculated_health = calculated_health*(1+0.1*PlayerData['Num_of_Green'])
	calculated_regen = calculated_regen*(1+0.3*PlayerData['Num_of_Green'])
	calculated_damage = calculated_damage*(1+0.1*PlayerData['Num_of_Red'])
	calculated_armor = calculated_armor + PlayerData['Num_of_Red']*1.5
	calculated_CD = calculated_CD * (1*pow(0.98,PlayerData['Num_of_Blue']))
	#ult cd with data

func _on_Timer_timeout():
	_process_stats()
	regen()

func level_up():
	PlayerData['Level'] += 1
	EXP_to_next_level = pow(PlayerData['Level'],2)*3 + 20
	var i = rng.randi_range(0,2)
	var keys = ['Red', 'Blue', 'Green']
	var key = keys[i]
	PlayerData['Num_of_%s' %key] += 1

func apply_modify():
	calculated_h_acc = base_h_acc
	calculated_h_cap= base_h_cap
	calculated_health = base_health
	calculated_regen = base_regen
	calculated_damage = base_damage
	calculated_armor = base_armor
	calculated_CD = base_CD
	
	for i in PlayerData["AddonsEquiped"]:
		var effect = DataLoader.addon_data[i]['effect']
		for j in effect['addition']:
			set("calculated_%s"%[j], get("calculated_%s"%[j])+effect['addition'][j])
		for j in effect['multiply']:
			set("calculated_%s"%[j], get("calculated_%s"%[j])*effect['multiply'][j])
