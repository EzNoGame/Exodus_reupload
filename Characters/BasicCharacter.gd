extends KinematicBody2D

class_name BasicCharacter

#health and armor
var health_curr = 100
var health_max = 100
var armor = 50

#damage
var damage_flat
var damage_floating

#velocity
var velocity = Vector2.ZERO
#gravity
var g_acc
var g_cap
#horizontal movemene speed
var h_acc
var h_cap
#jump
var j_acc
var j_cap

#animation player
onready var animation_player = $AnimationPlayer
var curr_anim = ""

#id & friendly
var id
var friendly

#random number generator
var rng

#toggle the script
var enable

#facing
var facing_right

func _ready():
	#initialize
	facing_right = true
	rng = RandomNumberGenerator.new()
	rng.randomize()
	health_curr = health_max
	enable = true
	
#call to update velocity and more state	
func _process(delta):
	update_velocity(delta)
	update_animation()
	
# apply physics
func _physics_process(delta):
	move_and_slide(velocity,Vector2.UP)

# calculate velocity
func update_velocity(delta):
	pass

#update animation
func update_animation():
	pass

#death handling
func death_handling():
	toggle_script_off()
	animation_player.play('death')
	yield(animation_player,'animation_finished')
	self.queue_free()

#pause script
func toggle_script_off():
	enable = false
	set_process(enable)
	set_physics_process(enable)

func toggle_script_on():
	enable = true
	set_process(enable)
	set_physics_process(enable)
	
#take damage, call when a hitbox enter the hurtbox
func take_damage(dmg):
	
	#take damage
	dmg = 100*dmg/(100+armor)
	health_curr -= dmg
	
	#adding floating text
	var dmg_display = preload("res://Characters/Addons/DamageDisplay.tscn").instance()
	dmg_display.get_node("LabelControl/Label").text = str(dmg)
	self.add_child(dmg_display)
	
	#play hit animation
	$AnimationPlayer.play("hit")
	
	if health_curr <= 0:
		death_handling()
