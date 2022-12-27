class_name AttackBox

extends Area2D

func _init() -> void:
	collision_layer = 2
	collision_mask = 0

func _ready() -> void:
	connect("area_entered", self, "on_area_entered")
	connect("area_exited", self, "on_area_exited")
	
func on_area_entered(hurtbox : HurtBox):
	if hurtbox == null:
		return 
		
	if not hurtbox.owner.get('friendly') == null and hurtbox.owner.friendly != owner.friendly:
		owner.attack_target.append(hurtbox.owner)

func on_area_exited(hurtbox : HurtBox):
	if hurtbox == null:
		return 
	
	if not hurtbox.owner.get('friendly') == null and hurtbox.owner.friendly != owner.friendly:
		owner.attack_target.erase(hurtbox.owner)
