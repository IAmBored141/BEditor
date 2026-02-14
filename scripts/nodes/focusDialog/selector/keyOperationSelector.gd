extends Selector
class_name keyOperationSelector

const ICONS:Array[Texture2D] = [
	preload("res://assets/ui/focusDialog/keySplitType/set.png"),
	preload("res://assets/ui/focusDialog/keySplitType/add.png"),
	preload("res://assets/ui/focusDialog/keySplitType/sub.png"),
	preload("res://assets/ui/focusDialog/keySplitType/times.png"),
	preload("res://assets/ui/focusDialog/keySplitType/div.png"),
	preload("res://assets/ui/focusDialog/keySplitType/mod.png"),
]

func _ready() -> void:
	columns = KeyBulk.OPERATIONS
	options = range(KeyBulk.OPERATIONS)
	defaultValue = KeyBulk.OPERATION.SET
	buttonType = keyOperationSelectorButton
	super()
	for button in buttons:
		var explanation:ControlExplanation
		match button.value:
			KeyBulk.OPERATION.SET: explanation = ControlExplanation.new("[%s]Set set operation", [&"focusOperationSet"])
			KeyBulk.OPERATION.ADD: explanation = ControlExplanation.new("[%s]Set addition operation", [&"focusOperationAdd"])
			KeyBulk.OPERATION.SUBTRACT: explanation = ControlExplanation.new("[%s]Set subtraction operation", [&"focusOperationSub"])
			KeyBulk.OPERATION.MULTIPLY: explanation = ControlExplanation.new("[%s]Set multiplication operation", [&"focusOperationMult"])
			KeyBulk.OPERATION.DIVIDE: explanation = ControlExplanation.new("[%s]Set division operation", [&"focusOperationDiv"])
			KeyBulk.OPERATION.MODULO: explanation = ControlExplanation.new("[%s]Set modulo operation", [&"focusOperationMod"])
		Explainer.addControl(button,explanation)

func setSelect(value:Variant) -> void:
	manuallySetting = true
	buttons[value].button_pressed = true
	manuallySetting = false
	selected = value

class keyOperationSelectorButton extends SelectorButton:
	var drawMain:RID

	func _init(_value:KeyBulk.OPERATION, _selector:keyOperationSelector):
		custom_minimum_size = Vector2(16,16)
		z_index = 1
		super(_value, _selector)
		icon = ICONS[value]
