extends "res://MainGame/ViewPortControll/CameraShake.gd"

var target = null

func _ready():
	pass

func _physics_process(delta):
	
	if target:
		position = target.position + Vector2(0, -80)
		
		if target.damage_taken != 0:
			target.damage_taken = 0
			shake(0.3,15,8)
