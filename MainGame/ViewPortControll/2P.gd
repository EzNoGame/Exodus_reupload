extends Node

onready var viewport1 = $Viewports/ViewportContainer1/Viewport1
onready var viewport2 = $Viewports/ViewportContainer2/Viewport2
onready var camera1 = $Viewports/ViewportContainer1/Viewport1/Camera2D
onready var camera2 = $Viewports/ViewportContainer2/Viewport2/Camera2D
onready var world = $Viewports/ViewportContainer1/Viewport1/MainGameScene
onready var stats_1 = $"Viewports/ViewportContainer1/1"
onready var stats_2 = $"Viewports/ViewportContainer2/2"

func _ready():
	if viewport1 != null:
		viewport2.world_2d = viewport1.world_2d
func _process(delta):
	if camera1.target == null:
		camera1.target = world.get_node("PlayerList/Player_1")
		stats_1.target = world.get_node("PlayerList/Player_1")
	if camera2.target == null:
		camera2.target = world.get_node("PlayerList/Player_2")
		stats_2.target = world.get_node("PlayerList/Player_2")
