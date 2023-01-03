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
