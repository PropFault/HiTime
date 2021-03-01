extends Node
export(NodePath)var _inventory;
onready var inventory = get_node(_inventory);
var equipment;


func add_equipment(node):
	print("Adding equipment ",  node.name)

func add_child(node, legible_unique_name=false):
	.add_child(node, legible_unique_name)
	add_equipment(node)

func remove_equipment(node):
	print("Removing equipment ", node.name)

func remove_child(node):
	.remove_child(node)
