extends CanvasLayer

var target

func _process(delta):
	if target == null:
		if get_parent().target != null:
			target = get_parent().target
	
	if target != null:
		$VBoxContainer/Green/Num_of_Green.text = '%sx'%[target.PlayerData['Num_of_Green']]
		$VBoxContainer/Blue/Num_of_Blue.text = '%sx'%[target.PlayerData['Num_of_Blue']]
		$VBoxContainer/Red/Num_of_Red.text = '%sx'%[target.PlayerData['Num_of_Red']]
		$Health.value = (target.health_curr * 100/ target.calculated_health)
		$Level.value = target.EXP*100/target.EXP_to_next_level
		
	if target and float(target.health_curr/ target.calculated_health) < 0.2:
		$Heart.offset = Vector2(rand_range(-1.0,1.0),rand_range(-1.0,1.0))
	else:
		$Heart.offset = Vector2(0,0)
