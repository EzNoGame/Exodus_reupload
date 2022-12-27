extends Hitbox

class_name BulletHitBox

func _ready():
	connect("area_entered", self, 'hurt_box_entered')
	connect("body_entered", self, 'wall_entered')
	
func hurt_box_entered(area) -> void:
	if area == null: 
		return
		
	elif area.owner.friendly != owner.friendly:
		self.owner.queue_free()
		
func wall_entered(body) -> void:
	if body == null:
		return
	
	if body.get_class() == 'TileMap':
		self.owner.queue_free()
