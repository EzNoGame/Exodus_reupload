extends Control

var NumOfPlayer = 0
var MapName = ""
var FilePath : String = "res://GameData/Temp.json"
var data

var dir = [Vector2.RIGHT, Vector2.LEFT, Vector2.UP, Vector2.DOWN]
var curr_pos = Vector2(0,0)
var rng = RandomNumberGenerator.new()
var walk_direction : int
onready var map = get_node("Map")
var room = preload("res://MainGame/Maps/Lab/Labs.tscn")
var test_room = preload("res://MainGame/Maps/Test_Room.tscn")
var Ladder_List = []
var cell_list = []

var elevator = preload("res://MainGame/Maps/Lab/objects/Player_Spawner.tscn")

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
	generate_map(10)
	#load_test_map()
	
	#load player
	NumOfPlayer = data["RoundData"]["NumOfPlayer"]
	for i in range(1, NumOfPlayer+1):
		var playernum = "Player%s" %[i]
		var character = "res://MainGame/Characters/Players/PumpKing/PumpKing.tscn"
		var player = load(character).instance()
		player.id = i
		player.set_name("Player_%s" % [i])
		var temp = elevator.instance()
		
		temp.position = Spawner.find_spawn_pos(map.get_node('CollisionLayer'),[25,1000], [25,1000], 4, 4)
		player.position = temp.position
		temp.player = player

		$ObjectList.add_child(temp)
		
	map_range_x = [map.get_node("CollisionLayer").get_used_rect().position.x, map.get_node("CollisionLayer").get_used_rect().end.x]
	map_range_y = [map.get_node("CollisionLayer").get_used_rect().position.y, map.get_node("CollisionLayer").get_used_rect().end.y]
		
	for i in range(30):
		var drawer = load("res://MainGame/Maps/Lab/objects/Drawer.tscn").instance()
		drawer.position = Spawner.find_spawn_pos(map.get_node('CollisionLayer'),[map_range_x[0]*16, map_range_x[1]*16], [map_range_y[0]*16, map_range_y[1]*16], 2, 2)
		
		$ObjectList.add_child(drawer)
		

func load_test_map():
	var testroom = test_room.instance()
	for v in testroom.get_used_cells():
		map.get_node("CollisionLayer").set_cellv(v,testroom.get_cellv(v))
		map.get_node("CollisionLayer").update_bitmask_area(v)
	for v in testroom.get_node("Ladder").get_used_cells():
		map.get_node("Ladder").set_cellv(v,testroom.get_node("Ladder").get_cellv(v))
		map.get_node("Ladder").update_bitmask_area(v)
		v += Vector2(0,1) 
		while map.get_node("CollisionLayer").get_cellv(v) == -1:
			map.get_node("Ladder").set_cellv(v, 0)
			map.get_node("Ladder").update_bitmask_area(v)
			v += Vector2(0,1) 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
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
	
func generate_map(lens):
	rng.set_seed(OS.get_unix_time())
	
	var temp = false
	var c = Cell.new()
	c.pos = Vector2(0,0)
	walk_direction = rng.randi_range(0,3)
	c.passable[walk_direction] = 1
	cell_list.append(c)
	curr_pos += dir[walk_direction]
	
	while len(cell_list) < lens:
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
			if len(cell_list) < lens-1:
				walk_direction = rng.randi_range(0,3)
				c.passable[walk_direction] = 1
				curr_pos += dir[walk_direction]
			cell_list.append(c)
		temp = false
		
	for i in cell_list:
		if sum(i.passable) == 0:
			load_room(i.pos,'NULL')
			
		elif sum(i.passable) == 4:
			load_room(i.pos, 'LRUD')

		elif sum(i.passable) == 1:
			if i.passable[0] == 1:
				load_room(i.pos, 'R')
			elif i.passable[1] == 1:
				load_room(i.pos, 'R', true)
			elif i.passable[2] == 1:
				load_room(i.pos, 'D', false, true)
			elif i.passable[3] == 1:
				load_room(i.pos, 'D')

		elif sum(i.passable) == 2:
			if i.passable[0] == 1 and i.passable[1] == 1:
				load_room(i.pos, 'LR')
			elif i.passable[2] == 1 and i.passable[3] == 1:
				load_room(i.pos, 'UD')
			elif i.passable[0] == 1 and i.passable[3] == 1:
				load_room(i.pos, 'RD',true)
			elif i.passable[0] == 1 and i.passable[2] == 1:
				load_room(i.pos, 'RD', true, true)
			elif i.passable[1] == 1 and i.passable[3] == 1:
				load_room(i.pos, 'RD', false)
			elif i.passable[1] == 1 and i.passable[2] == 1:
				load_room(i.pos, 'RD', false, true)

		elif sum(i.passable) == 3:
			if i.passable[0] == 0:
				load_room(i.pos, 'RUD')
			elif i.passable[1] == 0:
				load_room(i.pos, 'RUD', true)
			elif i.passable[2] == 0:
				load_room(i.pos, 'LRD')
			elif i.passable[3] == 0:
				load_room(i.pos, 'LRD', false, true)
				
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

func load_room(offset, roomtype, flipv = false, fliph = false):
	var _room = room.instance()
	var room_group = _room.get_node(roomtype)
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
	var trapdoor = load("res://MainGame/Maps/Lab/objects/trapdoor.tscn").instance()
	trapdoor.position = map.get_node("Ladder").map_to_world(pos)
	$ObjectList.add_child(trapdoor)
	pos += Vector2(0,1) 
	while map.get_node("CollisionLayer").get_cellv(pos) == -1:
		if map.get_node("Ladder").get_cellv(pos-Vector2(1,0)) == -1 and map.get_node("Ladder").get_cellv(pos+Vector2(1,0)) == -1:
			map.get_node("Ladder").set_cellv(pos, 0)
			map.get_node("Ladder").update_bitmask_area(pos)
		pos += Vector2(0,1) 
