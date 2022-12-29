extends Node2D

var data

func interact(id):
	var file = File.new()
	if file.open("Data/Run.json", File.READ) == OK:
		file.open("Data/Run.json", File.READ)
		var json = JSON.parse(file.get_as_text())
		file.close()
		data = json.result
	else:
		print("json file invalid")
		
	for i in get_parent().get_parent().get_node('PlayerList').get_children():
		i.PlayerData['Health'] = i.health_curr
		data['PlayersData']["Player%s"%[i.id]] = i.PlayerData
		
	file.open("Data/Run.json",File.WRITE)
	file.store_line(to_json(data))
	file.close()
	
	Transition.change_scene("res://Menu/Menus/FakeLoadingScreen.tscn")
