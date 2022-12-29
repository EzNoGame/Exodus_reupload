extends Node2D

class_name spawner

var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()

func find_spawn_pos(collision_layer,w_range,h_range,width,height):
	#get the whole map with all the used cell
	var raw_used_cell_list = collision_layer.get_used_cells()
	
	#world to map the range of spawning
	var start_pos = Vector2(w_range[0], h_range[0])
	var end_pos = Vector2(w_range[1],h_range[1])
	start_pos = collision_layer.world_to_map(start_pos)
	end_pos = collision_layer.world_to_map(end_pos)
	
	#get all the cell in range
	var used_cell_list = []
	for i in raw_used_cell_list:
		if i.x >= start_pos.x and i.x <= end_pos.x and i.y >= start_pos.y and i.y <= end_pos.y:
			used_cell_list.append(i)
			
	var index = rng.randi_range(0, len(used_cell_list))
	
	for i in range(index, len(used_cell_list)):
		if not check_avaliable(collision_layer,width,height,used_cell_list[i]):
			continue
		return collision_layer.map_to_world(used_cell_list[i] + Vector2((width/2), -(height/2)))
		
	for i in range(index-1, 0, -1):
		if not check_avaliable(collision_layer,width,height,used_cell_list[i]):
			continue
		return collision_layer.map_to_world(used_cell_list[i] + Vector2((width/2), -(height/2)))
		
	return Vector2(0,0)

func check_avaliable(collision_layer, width, height, pos):
	
	var on_roof = true
	for j in range(1, 30):
		if collision_layer.get_cellv(pos + Vector2(0,-j)) != -1:
			on_roof = false
	
	if not on_roof:
		for j in range (width):
				if collision_layer.get_cellv(pos + Vector2(j,0)) == -1:
					return false
					
		for j in range (width):
			for k in range (1, height):
				if collision_layer.get_cellv(pos+ Vector2(j, -k)) != -1:
					return false
		return true
		
	return false
