extends Node2D

var collisionLayer

var counter = 0

func interact(id):
	collisionLayer = get_parent().get_parent().get_node('Map/CollisionLayer')
	var range_x = [collisionLayer.get_used_rect().position.x, collisionLayer.get_used_rect().end.x]
	var range_y = [collisionLayer.get_used_rect().position.y, collisionLayer.get_used_rect().end.y]
	position = Spawner.find_spawn_pos(collisionLayer, 
	[range_x[0]*8, range_x[1]*8], 
	[range_y[0]*8, range_y[1]*8],
	DataLoader.object_data["Collector"].Width, 
	DataLoader.object_data["Collector"].Height)
	counter += 1
	
	if counter > 3:
		queue_free()
