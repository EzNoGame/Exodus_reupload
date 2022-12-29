extends Node2D

var object_data
var enemy_data
var character_data
var map_data

func _ready():
	
	# load the objects database
	var filepath = "res://Data/Objects.json"
	var file = File.new()
	if file.open(filepath, File.READ) == OK:
		file.open(filepath, File.READ)
		var json = JSON.parse(file.get_as_text())
		file.close()
		object_data = json.result
	else:
		print("json file invalid")
		
	#load the maps database
	filepath = "res://Data/Maps.json"
	file = File.new()
	if file.open(filepath, File.READ) == OK:
		file.open(filepath, File.READ)
		var json = JSON.parse(file.get_as_text())
		file.close()
		map_data = json.result
	else:
		print("json file invalid")
	
	#load the playable character data
	filepath = "res://Data/Characters.json"
	file = File.new()
	if file.open(filepath, File.READ) == OK:
		file.open(filepath, File.READ)
		var json = JSON.parse(file.get_as_text())
		file.close()
		character_data = json.result
	else:
		print("json file invalid")
