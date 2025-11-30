extends Resource
class_name ControlExplanation

@export var explanation:String
@export var hotkeys:Array[StringName]

func _init(_explanation:String="", _hotkeys:Array[StringName]=[]) -> void:
	explanation = _explanation
	hotkeys = _hotkeys

func _to_string() -> String:
	return explanation % hotkeys.map(Explainer.hotkeyMap)
