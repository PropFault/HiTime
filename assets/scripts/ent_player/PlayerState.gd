extends State
class_name PlayerState
export (NodePath) var _player
export (NodePath) var _inventory
export (NodePath) var _toolMgr
onready var player = get_node(_player)
onready var inventory = get_node(_inventory)
onready var toolMgr:ToolMgr = get_node(_toolMgr)

