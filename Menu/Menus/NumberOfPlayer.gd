extends Control

var data 
var FilePath : String = "res://Data/Run.json"

func _ready():
	$"VBoxContainer/2 Player".grab_focus()
	var file = File.new()
	if file.open(FilePath, File.READ) == OK:
		file.open(FilePath, File.READ)
		var json = JSON.parse(file.get_as_text())
		file.close()
		data = json.result
		data["MapName"] = 'Lab'
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
	data["NumOfPlayer"] = 2
	save_file_data()
	pass # Replace with function body.

func _on_3_Player_pressed():
	data["NumOfPlayer"] = 3
	save_file_data()
	pass # Replace with function body.

func _on_4_Player_pressed():
	data["NumOfPlayer"] = 4
	save_file_data()
	pass # Replace with function body.

func _on_Return_pressed():
	ButtonClickSfx.play()
	get_tree().root.get_child(4).UI_path = "res://Menu/Menus/MainMenu.tscn"
	get_tree().root.get_child(4).Swap = true
	queue_free()
