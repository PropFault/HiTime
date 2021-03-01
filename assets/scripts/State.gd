extends Node
class_name State
export(String)var stateIdentifier;
export(NodePath)var _stateManager;
onready var stateManager = get_node(_stateManager);
var stateEnabled = false
func onStateEnabled():
	stateEnabled = true

func onStateDisabled():
	stateEnabled = false
