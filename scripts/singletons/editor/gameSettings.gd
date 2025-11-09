extends MarginContainer
class_name GameSettings

const MAX_VOLUME:float = db_to_linear(-7)

func _volumeSet(value:float) -> void:
	AudioServer.set_bus_volume_linear(AudioManager.masterBus, lerpf(0,MAX_VOLUME,value))

func opened(configFile:ConfigFile) -> void:
	%volume.value = configFile.get_value("game", "volume", 0.5)

func closed(configFile:ConfigFile) -> void:
	configFile.set_value("game", "volume", %volume.value)
