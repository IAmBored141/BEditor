@abstract
extends GameComponent
class_name GameObject
# keybulks, doors, lily, etc

var active:bool = true

var gameMakerName:String

func stop() -> void:
	active = true
	propertyGameChangedDo(&"active")
