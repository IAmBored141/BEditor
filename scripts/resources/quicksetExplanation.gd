extends ControlExplanation
class_name QuicksetExplanation

var matches:Array[String]
var value:int

func _init(_explanation:String="", _hotkeys:Array[StringName]=[], _matches:Array[String]=[""], _value:int=0) -> void:
	super(_explanation, _hotkeys)
	matches = _matches
	value = _value

func _to_string() -> String:
	return (explanation % hotkeys.map(Explainer.hotkeyMap)).replace("$q", matches[value])
