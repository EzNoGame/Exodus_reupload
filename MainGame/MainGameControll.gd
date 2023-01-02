extends Control

var NumOfPlayer = 0
var MapName = ""
var FilePath : String = "res://Data/Run.json"
var data

var dir = [Vector2.RIGHT, Vector2.LEFT, Vector2.UP, Vector2.DOWN]
var curr_pos = Vector2(0,0)
var rng = RandomNumberGenerator.new()
var walk_direction : int
onready var map = get_node("Map")
var Ladder_List = []
var cell_list = []

var WINDOW_WIDTH = 640
var WINDOW_HEIGHT = 320

var map_range_x
var map_range_y

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
		
	# load map
	load_map(data)
	#load_test_map()

func load_test_map(room):
	
	for v in room.get_used_cells():
		map.get_node("CollisionLayer").set_cellv(v,room.get_cellv(v))
		map.get_node("CollisionLayer").update_bitmask_area(v)
	for v in room.get_node("Ladder").get_used_cells():
		map.get_node("Ladder").set_cellv(v,room.get_node("Ladder").get_cellv(v))
		map.get_node("Ladder").update_bitmask_area(v)
		v += Vector2(0,1) 
		while map.get_node("CollisionLayer").get_cellv(v) == -1:
			map.get_node("Ladder").set_cellv(v, 0)
			map.get_node("Ladder").update_bitmask_area(v)
			v += Vector2(0,1) 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	#player controler
	for i in $PlayerList.get_children():
		
		#bullet controll
		if i.need_to_add_bullet:
			$BulletList.add_child(i.bullet)
			i.need_to_add_bullet = false
		
		#death controll	
		if not i.is_living:
			i.is_living = true
	
	#enemy controll		
	for i in $EnemyList.get_children():
		
		#enemy clear out of range
		var in_range_of_player = false 
		for j in $PlayerList.get_children():
			if i.position.distance_to(j.position) < WINDOW_WIDTH*3:
				in_range_of_player = true
		if not in_range_of_player:
			i.queue_free()

func _on_BulletList_child_exiting_tree(node):
	if node.scored:
		get_node("PlayerList/%s" %[node.creator]).score += 5
		
#	var particle = load("res://Scenes/MainGame/particles/BulletParticle_1.tscn").instance()
#	particle.position = node.position
#	particle.emitting = true
#	get_node("ParticleList").add_child(particle)


func load_map(data):
	
	var room = load("res://MainGame/Maps/%s/%s.tscn" %[data["MapName"],data["MapName"]]).instance()
	#map.get_node("CollisionLayer").tile_set = room.get_node("CollisionLayer").tile_set
	
	match int(DataLoader.map_data[data["MapName"]].Map_Type):
		#procudural map geneartion
		0:
			#loading the basic collision and ladder layer
			generate_map(room, rng.randi_range(DataLoader.map_data[data["MapName"]].Number_of_Rooms_Min, DataLoader.map_data[data["MapName"]].Number_of_Rooms_Max))
			
		#fixed map generation
		1:
			load_test_map(room)
			
	print('sucessfully load map')
			
	map_range_x = [map.get_node("CollisionLayer").get_used_rect().position.x, map.get_node("CollisionLayer").get_used_rect().end.x]
	map_range_y = [map.get_node("CollisionLayer").get_used_rect().position.y, map.get_node("CollisionLayer").get_used_rect().end.y]
		
	#loading all the objects except player spawner
	load_objects(DataLoader.map_data[data["MapName"]].Number_of_Objects)
	print('sucessfully load objects')
	
	load_player()
	print("sucessfully load players")

func generate_map(room, size):
	
	rng.set_seed(OS.get_unix_time())
	
	var temp = false
	var c = Cell.new()
	c.pos = Vector2(0,0)
	walk_direction = rng.randi_range(0,3)
	c.passable[walk_direction] = 1
	cell_list.append(c)
	curr_pos += dir[walk_direction]
	
	#random walk
	while len(cell_list) < size:
		for j in cell_list:
			if j.pos == curr_pos:
				temp = true
				j.passable[get_inverse_dir(walk_direction)] = 1
				walk_direction = rng.randi_range(0,3)
				curr_pos += dir[walk_direction]
				j.passable[walk_direction] = 1
				break

		if not temp:
			c = Cell.new()
			c.pos = curr_pos
			c.passable[get_inverse_dir(walk_direction)] = 1
			if len(cell_list) < size-1:
				walk_direction = rng.randi_range(0,3)
				c.passable[walk_direction] = 1
				curr_pos += dir[walk_direction]
			cell_list.append(c)
		temp = false
		
	#fill the cornor
	for i in range(len(cell_list)):
		for j in range(len(cell_list[i].passable)):
			if cell_list[i].passable[j] == 0:
				var new_cell = true
				for k in cell_list:
					if k.pos == cell_list[i].pos + dir[j]:
						new_cell = false
						break
				if new_cell:
					c = Cell.new()
					c.pos = cell_list[i].pos + dir[j]
					cell_list.append(c)
	
	#load room	
	for i in cell_list:
		if sum(i.passable) == 0:
			load_room(room, i.pos,'NULL')
			
		elif sum(i.passable) == 4:
			load_room(room, i.pos, 'LRUD')

		elif sum(i.passable) == 1:
			match i.passable:
				[1,0,0,0]:
					load_room(room, i.pos, 'R')
				[0,1,0,0]:
					load_room(room, i.pos, 'R', true)
				[0,0,1,0]:
					load_room(room, i.pos, 'D', false, true)
				[0,0,0,1]:	
					load_room(room, i.pos, 'D')

		elif sum(i.passable) == 2:
			match i.passable:
				[1,1,0,0]:
					load_room(room, i.pos, 'LR')
				[0,0,1,1]:
					load_room(room, i.pos, 'UD')
				[1,0,0,1]:
					load_room(room, i.pos, 'RD',true)
				[1,0,1,0]:
					load_room(room, i.pos, 'RD', true, true)
				[0,1,0,1]:
					load_room(room, i.pos, 'RD', false)
				[0,1,1,0]:
					load_room(room, i.pos, 'RD', false, true)

		elif sum(i.passable) == 3:
			match i.passable:
				[0,1,1,1]:
					load_room(room, i.pos, 'RUD')
				[1,0,1,1]:
					load_room(room, i.pos, 'RUD', true)
				[1,1,0,1]:
					load_room(room, i.pos, 'LRD')
				[1,1,1,0]:
					load_room(room, i.pos, 'LRD', false, true)
				
	map.get_node("CollisionLayer").update_bitmask_region(map.get_node("CollisionLayer").get_used_rect().position,map.get_node("CollisionLayer").get_used_rect().end)
				
	for pos in Ladder_List:
		load_ladder(pos)
				
func get_inverse_dir(dir):
	if dir % 2 == 0:
		return dir + 1
	else:
		return dir - 1

func sum(list):
	var temp = 0
	for i in list:
		temp += i
	return temp

func load_room(room, offset, roomtype, flipv = false, fliph = false):
	var room_group = room.get_node(roomtype)
	var index = rng.randi_range(0, room_group.get_child_count()-1)
	var target_room = room_group.get_child(index)
	var ladder_room = room_group.get_child(index).get_child(0)
	var room_size = target_room.get_used_rect().size
	var map_offset = offset*room_size
		
	for v in target_room.get_used_cells():
		var _offset = map_offset+v
		if flipv:
			_offset = Vector2(map_offset.x + room_size.x - v.x - 1 , map_offset.y + v.y)
		if fliph:
			_offset = Vector2(map_offset.x + v.x, map_offset.y + room_size.y - v.y - 1)
		if flipv and fliph:
			_offset = Vector2(map_offset.x + room_size.x - v.x - 1, map_offset.y + room_size.y - v.y - 1)
		map.get_node("CollisionLayer").set_cellv(_offset, target_room.get_cellv(v))
	
	#get the place for placing ladder for later use	
	for v in ladder_room.get_used_cells():
		var _offset = map_offset+v
		if flipv:
			_offset = Vector2(map_offset.x + room_size.x - v.x - 1 , map_offset.y + v.y)
		if fliph:
			_offset = Vector2(map_offset.x + v.x, map_offset.y + room_size.y - v.y - 1)
		if flipv and fliph:
			_offset = Vector2(map_offset.x + room_size.x - v.x - 1, map_offset.y + room_size.y - v.y - 1)
		Ladder_List.append(_offset)

func load_ladder(pos):
	
	map.get_node("Ladder").set_cellv(pos,0)
	map.get_node("Ladder").update_bitmask_area(pos)
	
	#load the trap door 
	var trapdoor = load("res://MainGame/Objects/TrapDoor.tscn").instance()
	trapdoor.position = map.get_node("Ladder").map_to_world(pos)
	$ObjectList.add_child(trapdoor)
	
	#extend the ladder until it hit the floor
	pos += Vector2(0,1) 
	while map.get_node("CollisionLayer").get_cellv(pos) == -1:
		if map.get_node("Ladder").get_cellv(pos-Vector2(1,0)) == -1 and map.get_node("Ladder").get_cellv(pos+Vector2(1,0)) == -1:
			map.get_node("Ladder").set_cellv(pos, 0)
			map.get_node("Ladder").update_bitmask_area(pos)
		pos += Vector2(0,1) 

func load_objects(object_array):
	for key in object_array.keys():
		
		var value = object_array[key]
		var width = DataLoader.object_data[key].Width
		var height = DataLoader.object_data[key].Height
		for i in range (value):
			var object_i = load("res://MainGame/Objects/%s.tscn"%[key]).instance()
			object_i.position = Spawner.find_spawn_pos(
				map.get_node('CollisionLayer'),
				[map_range_x[0]*8, map_range_x[1]*8], 
				[map_range_y[0]*8, map_range_y[1]*8],
				width, 
				height)
			$ObjectList.add_child(object_i)

func load_player():
	for i in data["PlayersData"].keys():
		var player = load("res://MainGame/Characters/Players/%s/%s.tscn"%[data["PlayersData"][i]['Character'],data["PlayersData"][i]['Character']]).instance()
		var character = DataLoader.character_data[data["PlayersData"][i]['Character']]
		
		#base value of player
		player.name = "Player_%s"%[int(i)]
		player.id = int(i)
		player.base_health = character.Health
		player.base_armor = character.Armor
		player.base_CD = character.AttackSpeed * 60
		player.base_damage = character.Damage
		player.base_regen = character.Regen
		
		#changable value of player
		player.PlayerData = data['PlayersData'][i]
		player.health_curr = player.PlayerData['Health']
		
		var player_spawner = load("res://MainGame/Objects/PlayerSpawner.tscn").instance()
		player_spawner.position = Spawner.find_spawn_pos(
				map.get_node('CollisionLayer'),
				[map_range_x[0]*8, map_range_x[1]*8], 
				[map_range_y[0]*8, map_range_y[1]*8],
				DataLoader.object_data["PlayerSpawner"].Width, 
				DataLoader.object_data["PlayerSpawner"].Height)
		player_spawner.player = player
		$ObjectList.add_child(player_spawner)
