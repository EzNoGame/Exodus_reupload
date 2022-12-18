class_name LadderBox
extends Area2D

var climb = false

func _on_LadderBox_body_entered(body):
	climb = true

func _on_LadderBox_body_exited(body):
	climb = false
