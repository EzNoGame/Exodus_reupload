extends Control

func _ready():
	$Return.grab_focus()

func _on_Button_pressed():	
	ButtonClickSfx.play()
	get_parent().UI_path = "res://Menu/Menus/MainMenu.tscn"
	get_parent().Swap = true
	queue_free()
