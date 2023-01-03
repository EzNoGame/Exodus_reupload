extends Area2D

class_name interact_box

var player = []

var opened = false

func _ready():
	collision_mask = 4
	collision_layer = 4
	if get_overlapping_areas() != []:
		get_parent().queue_free()
	connect("body_entered", self, '_on_Area2D_body_entered')
	connect("body_exited", self, '_on_Area2D_body_exited')

func _on_Area2D_body_entered(body):
	if body == null:
		return
	
	else:
		player.append(body)

func _on_Area2D_body_exited(body):
	if body == null:
		return
	
	else:
		player.erase(body)


func _physics_process(delta):
	if not opened and len(player) > 0:
		get_parent().get_node("AnimationPlayer").play("Open")
		opened = true
	
	elif opened and len(player) == 0:
		get_parent().get_node("AnimationPlayer").play_backwards("Open")
		opened = false
	
	for i in player:
		if Input.is_action_pressed('interact_player_%s'%i.id):
			owner.interact(i)
