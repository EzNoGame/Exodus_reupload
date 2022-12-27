extends Area2D

var id = []

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
			owner.open(i)
