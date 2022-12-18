extends Node

onready var viewport1 = $Viewports/ViewportContainer1/Viewport1
onready var viewport2 = $Viewports/ViewportContainer2/Viewport2
onready var viewport3 = $Viewports/ViewportContainer3/Viewport3
onready var viewport4 = $Viewports/ViewportContainer4/Viewport4
onready var camera1 = $Viewports/ViewportContainer1/Viewport1/Camera2D
onready var camera2 = $Viewports/ViewportContainer2/Viewport2/Camera2D
onready var camera3 = $Viewports/ViewportContainer3/Viewport3/Camera2D
onready var camera4 = $Viewports/ViewportContainer4/Viewport4/Camera2D
onready var world = $Viewports/ViewportContainer1/Viewport1/MainGameScene

func _ready():
	if viewport1 != null:
		viewport2.world_2d = viewport1.world_2d
		viewport3.world_2d = viewport1.world_2d
		viewport4.world_2d = viewport1.world_2d
		camera1.target = world.get_node("PlayerList/Player_1")
		camera2.target = world.get_node("PlayerList/Player_2")
		camera3.target = world.get_node("PlayerList/Player_3")
		camera4.target = world.get_node("PlayerList/Player_4")
