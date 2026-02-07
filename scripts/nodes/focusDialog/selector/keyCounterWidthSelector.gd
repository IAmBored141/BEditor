extends Selector
class_name KeyCounterWidthSelector

const ICONS:Array[Texture2D] = [
	preload("res://assets/ui/focusDialog/lockConfiguration/AnyS.png"),
	preload("res://assets/ui/focusDialog/lockConfiguration/AnyM.png"),
	preload("res://assets/ui/focusDialog/lockConfiguration/AnyL.png"),
	preload("res://assets/ui/focusDialog/lockConfiguration/AnyXL.png"),
	preload("res://assets/ui/focusDialog/lockConfiguration/AnyXXL.png"),
]

func _ready() -> void:
	columns = 5
	options = range(5)
	defaultValue = 0
	buttonType = KeyCounterWidthSelectorButton
	super()

class KeyCounterWidthSelectorButton extends SelectorButton:
	var drawMain:RID

	func _init(_value:KeyBulk.TYPE, _selector:KeyCounterWidthSelector):
		custom_minimum_size = Vector2(16,16)
		z_index = 1
		super(_value, _selector)
		icon = ICONS[value]
