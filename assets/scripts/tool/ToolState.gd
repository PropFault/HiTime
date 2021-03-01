extends State
class_name ToolState
export(NodePath)var _animationTree
export(NodePath)var _owningTool
onready var animationTree = get_node(_animationTree)
onready var owningTool = get_node(_owningTool)
