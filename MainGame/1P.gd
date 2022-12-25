extends Node
func _process(delta):
	if $ViewportContainer/Viewport1/Camera2D.target == null:
		$ViewportContainer/Viewport1/Camera2D.target = $ViewportContainer/Viewport1/MainGameScene.get_node("PlayerList/Player_1")
	if $ViewportContainer/Player_stat.target == null:
		$ViewportContainer/Player_stat.target = $ViewportContainer/Viewport1/MainGameScene.get_node("PlayerList/Player_1")
