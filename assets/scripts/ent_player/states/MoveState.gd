extends PlayerState
class_name MoveState
export(float) var friction;
export(String) var actionL;
export(String) var actionR;

export(String) var actionF;
export(String) var actionB;

export(String) var actionJump;
export(float) var movementLRSpeed;
export(float) var movementFBSpeed;
export(float) var jumpStrength;
export(float)var minVelocity = 0.1;
export(String) var stateIdle;
var movement:Vector3 = Vector3()

func _process(delta):


	if self.stateEnabled:
		movement.x= Input.get_action_strength(actionR)-Input.get_action_strength(actionL)
		movement.z= Input.get_action_strength(actionB)-Input.get_action_strength(actionF)
		movement.y=Input.get_action_strength(actionJump)
		#self.player.velocity = Vector3(
		#	self.player.velocity.x * friction + movement.x * delta * movementLRSpeed, 
		#	self.player.velocity.y + movement.y * delta * jumpStrength, 
			#	self.player.velocity.z * friction + movement.z * delta * movementFBSpeed);
		var newV = self.player.velocity;
		newV += self.player.transform.basis.x * movement.x * delta * movementLRSpeed;
		newV += self.player.transform.basis.z * movement.z * delta * movementFBSpeed;
		newV *= friction;
		
		self.player.velocity = Vector3(newV.x * friction, self.player.velocity.y + movement.y * delta * jumpStrength, newV.z *friction)

func sigVelocityChanged(velocity):
	if velocity.length() < minVelocity:
		self.stateManager.changeState(stateIdle);
