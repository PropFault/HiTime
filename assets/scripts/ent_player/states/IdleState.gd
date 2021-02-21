extends PlayerState
class_name IdleState
export(float)var idleVelocity;
export(String)var stateMove;
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func sigVelocityChanged(velocity):
	if Vector3(velocity.x,0.0,velocity.z).length() > idleVelocity:
		self.stateManager.changeState(stateMove);
