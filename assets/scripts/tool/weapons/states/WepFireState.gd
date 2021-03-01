extends WeaponState
class_name WepFireState
export(Texture)var primaryFirePattern
export(String) var idleState;
export(bool) var fullAuto = false;
export(float)var RPS = 10
export(String)var animPropFirePrimary
export(float)var spread = 0.3
var firePattern:Dictionary
var firePatternIndex = 0
var timer:float = 999

func _ready():
	generateFirePattern()

func onStateEnabled():
	.onStateEnabled()
	self.fire()
	
func fire():
	if self.ammoManager.canSpendBullets():
		self.animationTree[animPropFirePrimary]=true
		self._fireProjectile((Vector3(firePattern.values()[firePatternIndex].x*spread,firePattern.values()[firePatternIndex].y*spread,1)).normalized())
		firePatternIndex = (firePatternIndex+1) % firePattern.size()
		timer = 0
func _process(delta):
	if self.stateEnabled:
		if timer > (1/RPS):
			fire()
		timer += delta

func _fireProjectile(var direction):
	pass
func fireAnimationFinished():
	self.ammoManager.spendBullets()
	self.animationTree[animPropFirePrimary]=false
	if not (fullAuto and Input.is_action_pressed("pFire")):
		self.stateManager.changeState(idleState)
		timer = 999
		firePatternIndex = 0

func generateFirePattern():
	firePattern.clear()
	var image = primaryFirePattern.get_data()
	image.lock()
	var imageSize = image.get_size()
	var sortHelper = Array()
	var tempDic = Dictionary()
	for x in range(0, imageSize.x):
		for y in range (0, imageSize.y):
			var color = image.get_pixel(x,y)
			var bgr = color.to_abgr32()
			var xRel = (x/imageSize.x)*2-1
			var yRel = (y/imageSize.y)*2-1
			tempDic[bgr] = Vector3(-xRel,-yRel,1).normalized();
			sortHelper.push_back(bgr);
	sortHelper.sort();
	for elem in sortHelper:
		firePattern[elem] = tempDic[elem];
