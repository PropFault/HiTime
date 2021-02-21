extends Node
class_name StateManager
export(Dictionary)var stateRegister;
export(String)var defaultState;
var activeState;

func _ready():
	self.changeState(defaultState);

func getState(var stateName):
	return get_node(stateRegister[stateName]);

func changeState(var stateName):
	if activeState != null:
		activeState.onStateDisabled();
	activeState = self.getState(stateName);
	activeState.onStateEnabled();
