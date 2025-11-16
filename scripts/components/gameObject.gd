@abstract
extends GameComponent
class_name GameObject
# keybulks, doors, lily, etc

var active:bool = true

func stop() -> void:
	active = true
	propertyGameChangedDo(&"active")
