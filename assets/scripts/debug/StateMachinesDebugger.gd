extends RichTextLabel

var stateMachines : Array

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func initStateMachines(var arr):
	for machine in arr:
		if machine.get_children().size() > 0:
			initStateMachines(machine.get_children())
		if machine is StateManager:
			stateMachines.push_back(machine)
# Called when the node enters the scene tree for the first time.
func _ready():
	initStateMachines(self.get_tree().root.get_children())


func _process(delta):
	self.text = ""
	for machine in stateMachines:
		self.text+= "Name: " + machine.name;
		self.text+= "\tActive State: " + machine.activeState.name
		self.text+="\n"
	
