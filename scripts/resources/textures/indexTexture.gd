extends GameTexture
class_name IndexTexture

@export var textures:Array[Texture2D]

func current() -> Texture2D: return textures[Game.goldIndex % len(textures)]
