extends Line2D

export var length = 50
var point = Vector2()
var pos = Vector2()

func _ready():
	set_as_toplevel(true)

func _process(delta):
	
	point = get_parent().global_position
	
	add_point(point)
	while get_point_count() > length:
		remove_point(0)
