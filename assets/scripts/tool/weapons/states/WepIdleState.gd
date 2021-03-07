extends WeaponState
class_name WepIdleState
export (String)var pFireState
export (String)var reloadState
var initialRun = true
func onStateEnabled():
	.onStateEnabled()
	initialRun = true
func _process(delta):
	if self.stateEnabled:
		if Input.is_action_pressed("pFire") and initialRun or Input.is_action_just_pressed("pFire"):
			self.stateManager.changeState(pFireState)
		if Input.is_action_pressed("reload"):
			self.stateManager.changeState(reloadState)
		initialRun = false
