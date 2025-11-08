extends Control
class_name KeepWorldScale

@onready var editor:Editor = get_node("/root/editor")

func _process(_delta):
	if Game.playState == Game.PLAY_STATE.PLAY: scale = Game.playCamera.zoom
	else: scale = Game.editorCamera.zoom
