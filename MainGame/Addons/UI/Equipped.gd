extends TextureButton

var addon_name = ""

func _ready():
	connect("focus_entered",self, "_on_button_entered")
	connect("pressed", self, "disrobe")

func _on_button_entered():
	if addon_name != "":
		var info_panel = get_parent().get_parent().get_node("Info")
		info_panel.get_node("TextureRect").texture = texture_normal
		info_panel.get_node("description").text = DataLoader.addon_data[addon_name]["Description"]
	else:
		var info_panel = get_parent().get_parent().get_node("Info")
		info_panel.get_node("TextureRect").texture = null
		info_panel.get_node("description").text = "Get more addons!"

func disrobe():
	if addon_name != "":
		get_parent().get_parent().disrobe(addon_name)
		addon_name = ""
		texture_normal = null
		_on_button_entered()
