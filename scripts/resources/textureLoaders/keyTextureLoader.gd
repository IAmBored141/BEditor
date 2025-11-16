extends TypeTextureLoader
class_name KeyTextureLoader

const TYPES:int = 6
enum TYPE {NORMAL, EXACT, STAR, UNSTAR, CURSE, UNCURSE}
const TYPE_NAMES:Array[String] = ["Normal", "Exact", "Star", "Unstar", "Curse", "Uncurse"]

func types() -> Array[int]: return rangei(TYPES)
func typeNames() -> Array[String]: return TYPE_NAMES
