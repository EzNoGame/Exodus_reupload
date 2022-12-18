extends Node
func _ready():
		$ViewportContainer/Viewport1/Camera2D.target = $ViewportContainer/Viewport1/MainGameScene.get_node("PlayerList/Player_1")
