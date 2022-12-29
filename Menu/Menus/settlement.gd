extends Control

var NumOfPlayer = 0
var FilePath : String = "res://Data/Run.json"
var data
# Called when the node enters the scene tree for the first time.
func _ready():
	# read data from the file
	var file = File.new()
	if file.open(FilePath, File.READ) == OK:
		file.open(FilePath, File.READ)
		var json = JSON.parse(file.get_as_text())
		file.close()
		data = json.result
	else:
		print("json file invalid")
	
	NumOfPlayer = data["RoundData"]["NumOfPlayer"]
	
	for i in range(NumOfPlayer):
		var label = Label.new()
		label.text = "%s : %s" %[data["RoundData"]["PlayersData"]["Player%s"%[i+1]],data["RoundData"]["Score"]["Player%s"%[i+1]]]
		$VBoxContainer.add_child(label)
