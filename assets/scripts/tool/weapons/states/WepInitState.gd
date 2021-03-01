extends WeaponState
class_name WepInitState
export(String)var idleState;

func animInitDone():
	self.stateManager.changeState(idleState)
