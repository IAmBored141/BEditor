extends MarginContainer
class_name TopBar

@onready var editor:Editor = get_node("/root/editor")
@onready var play:Button = %play

func _updateButtons() -> void:
	%modes.visible = Game.playState != Game.PLAY_STATE.PLAY and !editor.settingsOpen

	play.visible = Game.playState != Game.PLAY_STATE.PLAY and !editor.settingsOpen
	%pause.visible = Game.playState == Game.PLAY_STATE.PLAY and !editor.settingsOpen
	%stop.visible = Game.playState != Game.PLAY_STATE.EDIT and !editor.settingsOpen
	%settingTabs.visible = editor.settingsOpen

	play.disabled = !(Game.playState == Game.PLAY_STATE.PAUSED || Game.levelStart)

func _play() -> void: Game.playTest(Game.levelStart)
func _pause() -> void: Game.pauseTest()
func _stop() -> void: Game.stopTest()
