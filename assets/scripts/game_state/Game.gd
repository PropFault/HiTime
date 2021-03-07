extends Node

class Action:
	var tick
	var name
	var args:Dictionary
	var extras
	const  JSON_TICK = "tick"
	const  JSON_NAME = "name"
	const  JSON_ARGS = "args"
	const  JSON_EXTRAS = "extras"
	signal execute(action)
	func _init(var json):
		self.tick = json[JSON_TICK]
		self.name = json[JSON_NAME]
		if JSON_ARGS in json:
			self.args = json[JSON_ARGS]
		if JSON_EXTRAS in json:
			self.extras = json[JSON_EXTRAS]
	func to_json():
		return {JSON_TICK: self.tick, JSON_NAME: self.name, JSON_ARGS: self.args, JSON_EXTRAS: self.extras}
var timeline:Array
var lowestNewTick = 0
var tick = null
var indexLastEmitted = 0
signal KeyframePassed(action)

func startTimeline(var startTick):
	self.tick = startTick

func addKeyframe(var kf):
	timeline.append(kf)
	if lowestNewTick > kf.tick:
		lowestNewTick = kf.tick
	
func _physics_process(delta):
	if not tick == null:
		if lowestNewTick < tick:
			for i in range(indexLastEmitted, timeline.size()):
				var keyframe = timeline[i]
				if keyframe.tick >= lowestNewTick:
					keyframe.emit_signal("execute", keyframe)
					emit_signal("KeyframePassed", keyframe)
			indexLastEmitted = clamp(timeline.size()-1,0,99999999)
			lowestNewTick = tick
		tick += 1


func timeline_to_json():
	var json = {"tick": self.tick}
	json["actions"] = Array()
	for frame in timeline:
		json["actions"].append(frame.to_json())
	return json

func timeline_from_json(json):
	self.tick = json["tick"]
	if "actions" in json:
		for line in json["actions"]:
			self.timeline.append(Action.new(line))
