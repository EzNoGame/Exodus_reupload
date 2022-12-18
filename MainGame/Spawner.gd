extends Node2D

const SCREEN_WIDTH = 640
const SCREEN_HEIGHT = 360

var spawn_rate
var spawn_level

var player_pos_map = {}

var temp_enemy_list = []

var num = 0

var rng = RandomNumberGenerator.new()

var timer

onready var collision_map = owner.get_node('Map/CollisionLayer')
onready var player_list = owner.get_node('PlayerList')
onready var enemy_list = owner.get_node('EnemyList')

onready var dummy = preload("res://Characters/Enemies/Dummy/Dummy.tscn")

func _ready():
	print(SCREEN_WIDTH,SCREEN_HEIGHT)
	spawn_level = 1
	spawn_rate = 3
	timer = Timer.new()
	self.add_child(timer)
	timer.connect("timeout", self, "_on_Timer_timeout")
	timer.set_wait_time(spawn_rate)
	timer.set_one_shot(false) # Make sure it loops
	timer.start()
	rng.randomize()

func _on_Timer_timeout():
	spawn_level += 1 
	update_player_pos()
	
	for i in range(spawn_level):
		if enemy_list.get_child_count() >= 10:
			break
		var temp = dummy.instance()
		var target_player = rng.randi_range(1, len(player_pos_map))
		var h_range = [player_pos_map[target_player].x+(SCREEN_WIDTH)/2, player_pos_map[target_player].x-SCREEN_WIDTH/2]
		var v_range = [player_pos_map[target_player].y+SCREEN_HEIGHT/2, player_pos_map[target_player].y-SCREEN_HEIGHT/2]
		temp.position = find_spawn_pos(h_range,v_range)
		temp.name = str(num)
		enemy_list.add_child(temp)
			
#this function is used to keep track of players position
func update_player_pos():
	for i in player_list.get_children():
		player_pos_map[i.id] = i.get_global_position()
	
func find_spawn_pos(width, height):
	#first find a random position
	var pos = Vector2(rng.randi_range(width[0],width[1]), rng.randi_range(height[0], height[1]))
	var cell_pos = collision_map.world_to_map(pos)
	if collision_map.get_cellv(cell_pos) == -1 and collision_map.get_cellv(cell_pos+Vector2(0,1)) != -1 and collision_map.get_cellv(cell_pos+Vector2(0,-1)) == -1:
		return collision_map.map_to_world(cell_pos)
	else:
		return find_spawn_pos(width,height)
