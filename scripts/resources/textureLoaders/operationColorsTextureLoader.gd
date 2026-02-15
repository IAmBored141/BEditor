extends ColorsTextureLoader
class_name operationColorsTextureLoader

func initLoader(path:String,frames:int,params:Dictionary) -> OperatorTextureLoader:
	return OperatorTextureLoader.new(path,params.capitalised,frames)
