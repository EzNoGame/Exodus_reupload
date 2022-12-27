class_name LadderBox
extends Area2D

var climb = false
var id
var collide_with_ladder = false

func _ready():
	id = owner.id

func _process(delta):
	
	if (Input.is_action_pressed("up_player_%s" % [id]) or Input.is_action_pressed("down_player_%s" % [id])) and collide_with_ladder:
		climb = true
		
	elif not collide_with_ladder:
		climb = false	
		
func _on_LadderBox_body_entered(body):
	if body == null:
		return
	collide_with_ladder = true

func _on_LadderBox_body_exited(body):
	if body == null:
		return
	collide_with_ladder = false
