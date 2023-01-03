extends Node
var pause = false
func _process(delta):
	if $ViewportContainer/Viewport1/Camera2D.target == null:
		$ViewportContainer/Viewport1/Camera2D.target = $ViewportContainer/Viewport1/MainGameScene.get_node("PlayerList/Player_1")
	if $UI.target == null:
		$UI.target = $ViewportContainer/Viewport1/MainGameScene.get_node("PlayerList/Player_1")
