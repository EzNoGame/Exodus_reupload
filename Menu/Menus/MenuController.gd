extends Control

var UI_path = "res://Menu/Menus/MainMenu.tscn"
var Swap = false

# Called when the node enters the scene tree for the first time.
func _ready():
	var ui = load(UI_path).instance()
	self.add_child(ui)
	BgmPlayer.stream = load("res://sound effect/BGM/Major_BGM.mp3")
	BgmPlayer.play()

func _process(delta):
	if Swap == true:
		var ui = load(UI_path).instance()
		self.add_child(ui)
		Swap = false
