extends Node2D

var opened = false

var rng

func _ready():
	rng = RandomNumberGenerator.new()
	rng.randomize()

func interact(id):
	if not opened:
		opened = true
		var i = rng.randi_range(0,2)
		var target = get_parent().get_parent().get_node('PlayerList/Player_%s' %[id])
		var keys = target.chip_list.keys()
		var key = keys[i]
		target.chip_list[key]+=1
		$AnimationPlayer.play("open")
