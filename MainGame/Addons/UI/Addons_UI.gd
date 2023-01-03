extends CanvasLayer

var filepath = "Data/Run.json"

var data

var target

var red = 0
var blue = 0
var green = 0

func _process(delta):
	if target == null:
		if get_parent().target != null:
			target = get_parent().target

func appear():
	
	yield(get_tree().create_timer(0.01), "timeout")
	#read the player data
	var file = File.new()
	if file.open(filepath, File.READ) == OK:
		file.open(filepath, File.READ)
		var json = JSON.parse(file.get_as_text())
		file.close()
		data = json.result
	else:
		print("json file invalid")

	#show addons in inventory	
	var inventory = data["PlayersData"]["Player%s"%target.id]["AddonsInInventory"]
	var equiped = data["PlayersData"]["Player%s"%target.id]["AddonsEquiped"]
	for i in range(len(inventory)):
		var slot = $Addons_Stored.get_child(i)
		slot.texture_normal = load("MainGame/Addons/%s.png" %inventory[i])
		slot.addon_name = inventory[i]
	$Addons_Stored/TextureButton.grab_focus()
	
	#show addon equiped
	for i in range(len(equiped)):
		var slot = $Addons_Equiped.get_child(i)
		slot.texture_normal = load("MainGame/Addons/%s.png" %equiped[i])
		update_cost(equiped[i])
		slot.addon_name = equiped[i]
	update_text()
	show()	

func disappear():
	var file = File.new()
	file.open(filepath,File.WRITE)
	file.store_line(to_json(data))
	file.close()
	hide()
	
func equip(Name):
	if (red + DataLoader.addon_data[Name]["Cost"]["Red"] <= data["PlayersData"]["Player%s"%target.id]["Num_of_Red"] and
	blue + DataLoader.addon_data[Name]["Cost"]["Blue"] <= data["PlayersData"]["Player%s"%target.id]["Num_of_Blue"] and
	green + DataLoader.addon_data[Name]["Cost"]["Green"] <= data["PlayersData"]["Player%s"%target.id]["Num_of_Green"]):
		update_cost(Name)
		update_text()
		data["PlayersData"]["Player%s"%target.id]['AddonsInInventory'].erase(Name)
		data["PlayersData"]["Player%s"%target.id]['AddonsEquiped'].append(Name)
		for i in $Addons_Equiped.get_children():
			if i.texture_normal == null:
				i.texture_normal = load("res://MainGame/Addons/%s.png"%Name)
				i.addon_name = Name
				break
		return true
	return false

func disrobe(Name):
	red -= DataLoader.addon_data[Name]["Cost"]["Red"]
	blue -= DataLoader.addon_data[Name]["Cost"]["Blue"]
	green -= DataLoader.addon_data[Name]["Cost"]["Green"]
	update_text()
	data["PlayersData"]["Player%s"%target.id]['AddonsEquiped'].erase(Name)
	data["PlayersData"]["Player%s"%target.id]['AddonsInInventory'].append(Name)
	for i in $Addons_Stored.get_children():
			if i.texture_normal == null:
				i.texture_normal = load("res://MainGame/Addons/%s.png"%Name)
				i.addon_name = Name
				break

func update_cost(Name):
	red += DataLoader.addon_data[Name]["Cost"]["Red"]
	blue += DataLoader.addon_data[Name]["Cost"]["Blue"]
	green += DataLoader.addon_data[Name]["Cost"]["Green"]

func update_text():
	$VBoxContainer/Blue/Label.text = "%s/%s"%[blue, data["PlayersData"]["Player%s"%target.id]["Num_of_Blue"]]
	$VBoxContainer/Green/Label.text = "%s/%s"%[green, data["PlayersData"]["Player%s"%target.id]["Num_of_Green"]]
	$VBoxContainer/Red/Label.text = "%s/%s"%[red, data["PlayersData"]["Player%s"%target.id]["Num_of_Red"]]
