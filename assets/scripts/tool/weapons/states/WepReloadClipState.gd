extends WeaponState
class_name WepReloadClipState
export(String)var reloadAnimProperty;
export(String)var idleState

func onStateEnabled():
	.onStateEnabled()
	if ammoManager.canReload():
		self.animationTree[reloadAnimProperty] = true
	else:
		self.stateManager.changeState(idleState)

func onReloadAnimFinished():
	ammoManager.reload();
	self.animationTree[reloadAnimProperty] = false
	self.stateManager.changeState(idleState)
