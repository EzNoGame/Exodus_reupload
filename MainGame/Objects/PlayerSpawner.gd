extends Node2D

var player
var player_list

func _ready():
	player.position = self.get_global_position() + Vector2(32,32)
	player_list = get_parent().get_parent().get_node('PlayerList')
	yield(get_tree().create_timer(0.5), "timeout")
	$AudioStreamPlayer.play()
	
func spawn_player():
	player_list.add_child(player)
