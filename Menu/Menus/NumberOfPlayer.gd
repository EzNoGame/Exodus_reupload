extends Control

var data 
var FilePath : String = "res://GameData/Temp.json"

func _ready():
	$"VBoxContainer/2 Player".grab_focus()
	var file = File.new()
	if file.open(FilePath, File.READ) == OK:
		file.open(FilePath, File.READ)
		var json = JSON.parse(file.get_as_text())
		file.close()
		data = json.result
	else:
		print("json file invalid")

func save_file_data():
	var writeFile = File.new()
	writeFile.open(FilePath, File.READ_WRITE)
	writeFile.store_line(to_json(data))
	writeFile.close()
	ButtonClickSfx.play()
	Transition.change_scene("res://Menu/Menus/CharacterPicking.tscn")

func _on_2_Player_pressed():
	data["RoundData"]["NumOfPlayer"] = 2
	save_file_data()
	pass # Replace with function body.

func _on_3_Player_pressed():
	data["RoundData"]["NumOfPlayer"] = 3
	save_file_data()
	pass # Replace with function body.

func _on_4_Player_pressed():
	data["RoundData"]["NumOfPlayer"] = 4
	save_file_data()
	pass # Replace with function body.

func _on_Return_pressed():
	ButtonClickSfx.play()
	get_tree().root.get_child(3).Swap = true
	get_tree().root.get_child(3).UI_path = "res://Scenes/Menus/MainMenu.tscn"
	queue_free()