extends Control

var UI_path = "res://Menu/Menus/MainMenu.tscn"
var Swap = false

# Called when the node enters the scene tree for the first time.
func _ready():
	var ui = load(UI_path).instance()
	self.add_child(ui)
	pass # Replace with function body.

func _process(delta):
	if Swap == true:
		var ui = load(UI_path).instance()
		self.add_child(ui)
		Swap = false
