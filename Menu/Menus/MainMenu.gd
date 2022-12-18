extends Control

var data
var filepath = "res://GameData/Temp.json"

func _ready():
	$VBoxContainer/SinglePlayer.grab_focus()

func _on_SinglePlayer_pressed():
	data = {
		"RoundData" : {
			"NumOfPlayer" : 1,
			"MapName" : "",
			"PlayersData":{
				"Player1" : "PumpKing"
			},
			"Score":{}
		} 
	}
	var file = File.new()
	file.open(filepath,File.WRITE)
	file.store_line(to_json(data))
	file.close()
	ButtonClickSfx.play()
	Transition.change_scene("res://Menu/Menus/CharacterPicking.tscn")
	
func _on_MultiPlayer_pressed():
	data = {
		"RoundData" : {
			"NumOfPlayer" : "",
			"MapName" : "",
			"PlayersData":{
				"Player1" : "PumpKing",
				"Player2" : "PumpKing"
			},
			"Score":{}
		} 
	}
	var file = File.new()
	file.open(filepath,File.WRITE)
	file.store_line(to_json(data))
	file.close()
	ButtonClickSfx.play()    
	get_tree().root.get_node('/root/MenuController').Swap = true
	get_tree().root.get_node('/root/MenuController').UI_path = "res://Menu/Menus/NumberOfPlayer.tscn"
	queue_free()
	

func _on_Option_pressed():
	ButtonClickSfx.play()
	get_tree().root.get_node('/root/MenuController').Swap = true
	get_tree().root.get_node('/root/MenuController').UI_path = "res://Menu/Menus/Option.tscn"
	queue_free()

func _on_Quit_pressed():
	ButtonClickSfx.play()
	get_tree().quit()

