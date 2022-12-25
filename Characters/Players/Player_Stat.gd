extends Node2D

var target

func _process(delta):
	if target != null:
		$Control/Num_of_Green.text = '%sx'%[target.chip_list['num_green_chip']]
		$Control/Num_of_Blue.text = '%sx'%[target.chip_list['num_blue_chip']]
		$Control/Num_of_Red.text = '%sx'%[target.chip_list['num_red_chip']]
		$Control/Health.value = (target.health_curr * 100/ target.calculated_health)
		$Control/Level.value = target.EXP*100/target.EXP_to_next_level
