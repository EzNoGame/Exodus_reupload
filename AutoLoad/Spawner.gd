extends Node2D

class_name spawner

var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()

func find_spawn_pos(collision_layer,w_range,h_range,width,height):
	#first find a random position
	var pos = Vector2(rng.randi_range(w_range[0],w_range[1]), rng.randi_range(h_range[0], h_range[1]))
	var cell_pos = collision_layer.world_to_map(pos) - Vector2(int(width/2), int(height/2))
	
	for i in range (width):
		for j in range(height):
			if collision_layer.get_cellv(cell_pos + Vector2(i,j)) != -1:
				return find_spawn_pos(collision_layer,w_range,h_range,width,height)
	for i in range(width):
		if collision_layer.get_cellv(cell_pos+Vector2(i,height)) == -1:
			return find_spawn_pos(collision_layer,w_range,h_range,width,height)
			
	return collision_layer.map_to_world(cell_pos + Vector2(int(width/2), int(height/2)))
