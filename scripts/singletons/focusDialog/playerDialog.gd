extends Control
class_name PlayerDialog

@onready var editor:Editor = get_node("/root/editor")
@onready var main:FocusDialog = get_parent()

var color:Game.COLOR

func focus(_focused:PlayerPlaceholderObject, new:bool) -> void:
	if new:
		setSelectedColor(Game.COLOR.WHITE)
		if !main.interacted: main.interact(%playerKeyCountEdit.realEdit)

func setSelectedColor(toColor:Game.COLOR) -> void:
	%playerColorSelector.setSelect(toColor)
	_playerColorSelected(toColor)

func _playerColorSelected(_color:Game.COLOR) -> void:
	color = _color
	%playerKeyCountEdit.setValue(Game.player.key[color])
	%playerStar.button_pressed = Game.player.star[color]
	%playerCurse.button_pressed = Game.player.curse[color]

func changedMods() -> void:
	%playerCurse.visible = Mods.active(&"C5")

func _playerKeyCountSet(value:PackedInt64Array) -> void:
	Game.player.key[color] = value
	Game.player.checkKeys()

func _playerStarSet(toggled_on:bool) -> void:
	Game.player.star[color] = toggled_on

func _playerCurseSet(toggled_on:bool) -> void:
	Game.player.curse[color] = toggled_on
	Game.player.checkKeys()
