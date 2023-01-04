extends Control

var rng = RandomNumberGenerator.new()
var FilePath : String = "res://Data/Run.json"
var data = {}

func _ready():
	var file = File.new()
	if file.open(FilePath, File.READ) == OK:
		file.open(FilePath, File.READ)
		var json = JSON.parse(file.get_as_text())
		file.close()
		data = json.result
	else:
		print("json file invalid")
	yield(get_tree().create_timer(3.0), "timeout")
	Transition.change_scene("res://MainGame/ViewPortcontroll/%sP.tscn" %data["NumOfPlayer"])
