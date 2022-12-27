extends KinematicBody2D

class_name BasicCharacter

#health and armor
var health_curr = 100
var base_health = 100
var base_armor = 50
var base_regen = 0.1
#damage
var base_damage
var damage_floating

var calculated_health
var calculated_armor
var calculated_regen
var calculated_damage

var target

var EXP = 0

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
var friendly

#random number generator
var rng

#toggle the script
var enable

#facing
var facing_right
var creator = ""

var state_machine

func _ready():
	#initialize
	facing_right = true
	rng = RandomNumberGenerator.new()
	rng.randomize()
	calculated_health = base_health
	calculated_armor = base_armor
	calculated_damage = base_damage
	calculated_regen = base_regen
	health_curr = calculated_health
	enable = true
	state_machine = $AnimationTree.get("parameters/playback")
	
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
	pass
	

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
func take_damage(target):
	
	#take damage
	var dmg = 100*target.damage/(100+calculated_armor)
	health_curr -= dmg
	
	#adding floating text
	var dmg_display = preload("res://MainGame/Characters/Addons/DamageDisplay.tscn").instance()
	dmg_display.get_node("LabelControl/Label").text = str(int(dmg))
	dmg_display.position = self.get_global_position()
	get_parent().get_parent().add_child(dmg_display)
