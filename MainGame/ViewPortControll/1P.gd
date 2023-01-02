extends Node
var pause = false
func _process(delta):
	if $ViewportContainer/Viewport1/Camera2D.target == null:
		$ViewportContainer/Viewport1/Camera2D.target = $ViewportContainer/Viewport1/MainGameScene.get_node("PlayerList/Player_1")
	if $UI/Player_stat.target == null:
		$UI/Player_stat.target = $ViewportContainer/Viewport1/MainGameScene.get_node("PlayerList/Player_1")
		
	if Input.is_action_just_pressed("Addons_player_1"):
		if not pause:
			var addon = load("res://MainGame/Addons/UI/Addons_UI.tscn").instance()
			addon.name = "Menu"
			addon.target = $ViewportContainer/Viewport1/MainGameScene.get_node("PlayerList/Player_1")
			$UI.add_child(addon)
			pause = true
		else:
			$UI/Menu.queue_free()
			pause = false
