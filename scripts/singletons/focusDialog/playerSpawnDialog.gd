extends Control
class_name PlayerSpawnDialog

@onready var editor:Editor = get_node("/root/editor")
@onready var main:FocusDialog = get_parent()

func focus(focused:PlayerSpawn, _new:bool) -> void:
	if Game.levelStart == focused: %levelStart.button_pressed = true
	else: %savestate.button_pressed = true

func _setLevelStart() -> void:
	if main.focused is not PlayerSpawn: return
	if Game.levelStart:
		Game.levelStart.queue_redraw()
	Changes.addChange(Changes.GlobalObjectChange.new(Game,&"levelStart",main.focused))
	main.focused.queue_redraw()

func _setSavestate() -> void:
	if main.focused is not PlayerSpawn: return
	if Game.levelStart == main.focused:
		Changes.addChange(Changes.GlobalObjectChange.new(Game,&"levelStart",null))
		main.focused.queue_redraw()

func _playTest() -> void:
	Game.playTest(main.focused)
