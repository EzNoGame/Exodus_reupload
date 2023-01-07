extends CanvasLayer

var target

func _process(delta):
	if target == null:
		if get_parent().target != null:
			target = get_parent().target
			
	if target and float(target.health_curr/ target.calculated_health) < 0.15:
		visible = true
	else:
		visible = false
