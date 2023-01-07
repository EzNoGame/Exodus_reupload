extends "res://MainGame/Effects/Effect.gd"

var modulate

func _ready():
	modulate = target.modulate
	target.modulate = Color(1.5,2,1.5)

func _on_timer_timeout():
	target.take_damage_by_effect(1,true)

func reset():
	target.modulate = modulate
