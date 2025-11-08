extends Container
class_name BetterAspectRatioContainer

@export var ratio:Vector2 = Vector2(800, 608)

func _notification(what:int) -> void:
	match what:
		NOTIFICATION_SORT_CHILDREN:
			for control in get_children():
				if control is not Control: continue
				if size.x*ratio.y/size.y > ratio.x:
					control.size = Vector2(size.y*ratio.x/ratio.y,size.y)
					control.position = Vector2((size.x-control.size.x)/2,0)
				elif size.x*ratio.y/size.y < ratio.x:
					control.size = Vector2(size.x,size.x*ratio.y/ratio.x)
					control.position = Vector2(0,(size.y-control.size.y)/2)
				else:
					control.size = Vector2(size.x,size.y)
					control.position = Vector2.ZERO
