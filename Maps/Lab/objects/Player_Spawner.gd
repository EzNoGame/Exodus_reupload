extends Node2D

var player
var player_list

func _ready():
	player_list = get_parent().get_parent().get_node('PlayerList')
	
func spawn_player():
	player_list.add_child(player)
