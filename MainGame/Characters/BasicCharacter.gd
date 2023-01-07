extends KinematicBody2D

class_name BasicCharacter

#health and armor
var health_curr
var base_health
var base_armor
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

#animation controll
onready var animation_player = $AnimationPlayer
var state_machine
var animation
var curr_anim = ""

#Friendly: to determien wether the player can attack it or not
var friendly

#random number generator
var rng

#controll physic process
var enable

#facing
var facing_right
var creator = ""

#effct, buff/debuff that act on the character
onready var effect_list = $EffectList # the effect list store the all the effect that is applied on the charatcer

func _ready():
	#initialize
	facing_right = true
	rng = RandomNumberGenerator.new()
	rng.randomize()
	calculated_health = base_health
	calculated_armor = base_armor
	calculated_damage = base_damage
	calculated_regen = base_regen
	enable = true
	state_machine = $AnimationTree.get("parameters/playback")



# update per frame, controll basic movement and animation
func _physics_process(delta):
	var _delta = delta * 60
	update_velocity(_delta)
	update_animation()
	move_and_slide(velocity,Vector2.UP)

# calculate velocity
func update_velocity(delta):
	pass

#update animation
func update_animation():
	pass



func _process(delta):
	remove_expired_effect()

#handling the death process of the character
func death_handling():
	pass


	
#script controll
func toggle_script_off():
	enable = false
	set_physics_process(enable)

func toggle_script_on():
	enable = true
	set_physics_process(enable)
	


#take damage, call when a hitbox enter the hurtbox
func take_damage(target):
	
	#take damage
	var dmg = 100*target.damage/(100+calculated_armor)
	health_curr -= dmg
	if health_curr< 0:
		death_handling()
	
	#adding floating text
	var dmg_display = preload("res://MainGame/Characters/Addons/DamageDisplay.tscn").instance()
	dmg_display.get_node("LabelControl/Label").text = str(int(dmg))
	dmg_display.position = self.get_global_position()
	get_parent().get_parent().add_child(dmg_display)

func take_damage_by_effect(damage, pericing):
	var dmg
	if pericing:
		dmg = damage
	else:
		dmg = 100*damage/(100+calculated_armor)
		
	health_curr -= dmg
	if health_curr< 0:
		death_handling()
	
	#adding floating text
	var dmg_display = preload("res://MainGame/Characters/Addons/DamageDisplay.tscn").instance()
	dmg_display.get_node("LabelControl/Label").text = str(int(dmg))
	dmg_display.position = self.get_global_position()
	get_parent().get_parent().add_child(dmg_display)
	
#effect controll
func add_effect(type, duration):
	var effect = load("MainGame/Effects/%s.tscn"%[type]).instance()
	effect.target = self
	effect.duration = duration
	effect_list.add_child(effect)

func remove_expired_effect():
	for i in effect_list.get_children():
		if i.duration <= 0:
			i.reset()
			i.queue_free()
