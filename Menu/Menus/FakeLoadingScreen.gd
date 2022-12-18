extends Control

var rng = RandomNumberGenerator.new()
var bgm = preload("res://sound effect/BGM/lab.mp3")
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

func _process(delta):
	if rng.randf_range(1,10) > 7:
		get_node("VBoxContainer/ProgressBar").value += rng.randf_range(1,5)
	if $VBoxContainer/ProgressBar.value >= $VBoxContainer/ProgressBar.max_value:
		BgmPlayer.stream = bgm
		BgmPlayer.play()
		get_tree().change_scene("res://MainGame/%sP.tscn" %data["RoundData"]["NumOfPlayer"])
