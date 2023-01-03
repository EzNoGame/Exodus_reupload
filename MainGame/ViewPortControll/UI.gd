extends CanvasLayer

var target

var pause = false

func _physics_process(delta):
	if target != null:
		if Input.is_action_just_pressed("Addons_player_%s" %target.id):
			
			if not pause:
				$Addon_UI.appear()
				pause = true
				
			else:
				$Addon_UI.disappear()
				pause = false
