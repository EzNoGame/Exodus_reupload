extends Control
var curr_player_id = 1
var curr_player_char = "PumpKing"
var data
var num_of_player : int
var FilePath : String = "res://Data/Run.json"

func _ready():
	$CharacterList/PumpKing.grab_focus()
	
	var file = File.new()
	if file.open(FilePath, File.READ) == OK:
		file.open(FilePath, File.READ)
		var json = JSON.parse(file.get_as_text())
		file.close()
		data = json.result
	else:
		print("json file invalid")
	
	for button in get_tree().get_nodes_in_group("characters"):
		button.connect("pressed", self, "_some_button_pressed", [button])
	
	pass

func _some_button_pressed(button):
	ButtonClickSfx.play()
	curr_player_char = button.name
	
	data["PlayersData"]["Player%s" %[curr_player_id]]['Character'] = button.name
	data["PlayersData"]["Player%s" %[curr_player_id]]['Num_of_Red'] = 0
	data["PlayersData"]["Player%s" %[curr_player_id]]['Num_of_Green'] = 0
	data["PlayersData"]["Player%s" %[curr_player_id]]['Num_of_Blue'] = 0
	data["PlayersData"]["Player%s" %[curr_player_id]]['Health'] = 100
	data["PlayersData"]["Player%s" %[curr_player_id]]['EXP'] = 0
	data["PlayersData"]["Player%s" %[curr_player_id]]['Level'] = 0
	data["PlayersData"]["Player%s" %[curr_player_id]]['AddonsInInventory'] = []
	data["PlayersData"]["Player%s" %[curr_player_id]]['AddonsEquiped'] = []
	curr_player_id += 1
	
	if curr_player_id > data["NumOfPlayer"]:
		for i in $CharacterList.get_children():
			i.disabled = true
		set_process(false)
		var savefile = File.new()
		savefile.open(FilePath, File.WRITE)
		savefile.store_line(to_json(data))
		savefile.close()
		Transition.change_scene("res://Menu/Menus/FakeLoadingScreen.tscn")
		
	pass # Replace with function body.

func _process(delta):
	curr_player_char = get_focus_owner().name
	if curr_player_char == "Return":
		get_node("Label").text = ""
	else:
		get_node("Label").text = "Now Player %s is picking: %s" %[curr_player_id, curr_player_char]
	pass

func _on_Return_pressed():
	Transition.change_scene("res://Menu/Menus/MenuController.tscn")
