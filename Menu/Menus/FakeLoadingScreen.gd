extends Control

var rng = RandomNumberGenerator.new()
var bgm = preload("res://sound effect/BGM/airtone_-_blackSnow_1.mp3")
var FilePath : String = "res://GameData/Temp.json"
var data = {}

func _ready():
	BgmPlayer.stop()
	var file = File.new()
	if file.open(FilePath, File.READ) == OK:
		file.open(FilePath, File.READ)
		var json = JSON.parse(file.get_as_text())
		file.close()
		data = json.result
	else:
		print("json file invalid")
	yield(get_tree().create_timer(3.0), "timeout")
	BgmPlayer.stream = bgm
	BgmPlayer.play()
	Transition.change_scene("res://MainGame/ViewPortcontroll/%sP.tscn" %data["RoundData"]["NumOfPlayer"])
