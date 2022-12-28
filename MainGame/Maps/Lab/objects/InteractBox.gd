extends Area2D

class_name interact_box

var id = []

func _ready():
	collision_mask = 4
	collision_layer = 0

func _on_Area2D_body_entered(body):
	if body == null:
		return
	
	else:
		id.append(body.id)

func _on_Area2D_body_exited(body):
	if body == null:
		return
	
	else:
		id.erase(body.id)


func _process(delta):
	for i in id:
		if Input.is_action_pressed('interact_player_%s'%[i]):
			owner.interact(i)
