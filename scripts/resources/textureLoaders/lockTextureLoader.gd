extends TypeTextureLoader
class_name LockTextureLoader

const SIZE_TYPE_NAMES:Array[String] = ["AnyS", "AnyH", "AnyV", "AnyM", "AnyL", "AnyXL", "ANY"]

func _init(path:String, _frames:int=1) -> void: super(path,true,_frames)

func types() -> Array[int]: return rangei(Lock.SIZE_TYPES)
func typeNames() -> Array[String]: return SIZE_TYPE_NAMES
