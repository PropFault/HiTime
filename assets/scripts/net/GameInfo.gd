extends Resource
class_name GameInfo
export(String)var gamemodeName;
export(String)var currentMap;
func _init(var json = {"name": "???", "currentMap": "???"}):
	self.gamemodeName = json["name"]
	self.currentMap = json["currentMap"]

func to_json():
	return { "name": self.gamemodeName, "currentMap": self.currentMap}
