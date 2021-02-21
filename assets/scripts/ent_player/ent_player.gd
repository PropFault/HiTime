extends KinematicBody
class_name EntPlayer
export(Vector3)var gravity;
export(NodePath)var _stateManager;
onready var stateManager = get_node(_stateManager);
var velocity:Vector3 setget setVelocity, getVelocity;
signal velocityChanged(velocity)

func setVelocity(var newV):
	velocity = newV;
	emit_signal("velocityChanged",newV);
func getVelocity():
	return velocity
func _ready():
	pass
	
func _physics_process(delta):
	self.velocity = self.move_and_slide(self.velocity)
	self.velocity +=gravity*delta
