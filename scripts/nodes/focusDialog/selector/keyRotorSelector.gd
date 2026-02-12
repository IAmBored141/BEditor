extends Selector
class_name KeyRotorSelector

const VALUES:int = 4
enum VALUE {NULL, SIGNFLIP, POSROTOR, NEGROTOR}

var isInRecMode:bool = false

const ICONS:Array[Texture2D] = [
	preload("res://assets/ui/focusDialog/keySplitType/null.png"),
	preload("res://assets/ui/focusDialog/keySplitType/signflip.png"),
	preload("res://assets/ui/focusDialog/keySplitType/posrotor.png"),
	preload("res://assets/ui/focusDialog/keySplitType/negrotor.png"),
]

const OTHERICONS:Array[Texture2D] = [
	preload("res://assets/ui/focusDialog/keySplitType/reci.png"),
	preload("res://assets/ui/focusDialog/keySplitType/reciflip.png"),
	preload("res://assets/ui/focusDialog/keySplitType/recipos.png"),
	preload("res://assets/ui/focusDialog/keySplitType/recineg.png"),
]

func _ready() -> void:
	columns = VALUES
	options = range(VALUES)
	defaultValue = VALUE.SIGNFLIP
	buttonType = KeyRotorSelectorButton
	super()

func _process(_delta) -> void: # idk how to properally format in changes.gd
	if Mods.active(&"Fractions") and isInRecMode:
		buttons[0].show()
		for i in range(len(buttons)):
			buttons[i].icon = OTHERICONS[i]
	else:
		buttons[0].hide()
		for i in range(len(buttons)):
			buttons[i].icon = ICONS[i]

func setValue(count:PackedInt64Array) -> void:
	if M.eq(count, M.ONE) and isInRecMode: setSelect(VALUE.NULL) # should be unreachable if not in reciprocate mode
	elif M.eq(count, M.nONE) or (!isInRecMode and M.eq(count, M.ONE)): setSelect(VALUE.SIGNFLIP)
	elif M.eq(count, M.I): setSelect(VALUE.POSROTOR)
	elif M.eq(count, M.nI): setSelect(VALUE.NEGROTOR)

class KeyRotorSelectorButton extends SelectorButton:
	var drawMain:RID

	func _init(_value:VALUE, _selector:KeyRotorSelector):
		custom_minimum_size = Vector2(16,16)
		z_index = 1
		super(_value, _selector)
		icon = ICONS[value]
