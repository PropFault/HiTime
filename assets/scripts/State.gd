extends Node
class_name State
export(String)var stateIdentifier;
export(NodePath)var _stateManager;
onready var stateManager = get_node(_stateManager);
func onStateEnabled():
	pass

func onStateDisabled():
	pass
