extends Node2D

var opened = false

var rng

func _ready():
	rng = RandomNumberGenerator.new()
	rng.randomize()

func interact(player):
	if not opened:
		opened = true
		var i = rng.randi_range(0,2)
		var target = get_parent().get_parent().get_node('PlayerList/Player_%s' %[player.id])
		var keys = ['Red', 'Blue', 'Green']
		var key = keys[i]
		target.PlayerData['Num_of_%s'%key]+=1
		$AnimationPlayer.play("open")
