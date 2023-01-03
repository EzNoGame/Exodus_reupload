extends Control

func playSFX(name):
	var player = load("res://AutoLoad/SFXPlayer.tscn").instance()
	player.set_stream(load(name))
	player.autoplay = true
	add_child(player)
