extends TypeTextureLoader
class_name OperatorTextureLoader

const TYPES:int = 6
enum TYPE {SET, ADD, SUBTRACT, MULTIPLY, DIVIDE, MODULO}
const TYPE_NAMES:Array[String] = ["set", "add", "subtract", "multiply", "divide", "modulo"]

func types() -> Array[int]: return rangei(TYPES)
func typeNames() -> Array[String]: return TYPE_NAMES
