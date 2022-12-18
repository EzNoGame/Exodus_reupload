extends Player

func _ready():
	self.health_max = 100
	self.health = health_max
	self.acc = 150
	self.horizontal_velocity_cap = 500
	self.ulting_frame = 5
	self.basic_att_bullet = preload("res://Scenes/MainGame/Bullets/CyberCowboyBullet.tscn")
	self.ult_bullet = preload("res://Scenes/MainGame/Bullets/PumpKingHead.tscn")

func particle_effect_controll():
	if is_on_floor() and abs(velocity.x) > 50:
		$ViewportContainer/Viewport/WalkingDust.emitting = true
	else:
		$ViewportContainer/Viewport/WalkingDust.emitting = false

func ult():
	if curr_ult_cd < max_ult_cd:
		curr_ult_cd += 1
		
	if Input.is_action_just_pressed("ult_player_%s" %[id]) and curr_ult_cd == max_ult_cd:
		print("an ult has been pressed")
		curr_ult_cd = 0
		is_channeling = true
		animation = "Ult"
		bullet = ult_bullet.instance()
		bullet.position = Vector2(get_global_position().x, get_global_position().y-30)
		bullet.direction = face_right
		bullet.creator = name
		need_to_add_bullet = true
		$AnimatedSprite.play(animation)
	
	if $AnimatedSprite.animation == "Ult" and $AnimatedSprite.frame == ulting_frame:
		is_channeling = false
