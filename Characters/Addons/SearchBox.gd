class_name SearchBox

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
		owner.target.append(hurtbox.owner)
		owner.target_pos = hurtbox.owner.get_global_position()

func on_area_exited(hurtbox : HurtBox):
	if hurtbox == null:
		return 
	
	if not hurtbox.owner.get('friendly') == null and hurtbox.owner.friendly != owner.friendly:
		owner.target.erase(hurtbox.owner)
