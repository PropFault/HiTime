extends Spatial
class_name WeaponHitscan
export(float)var primaryRPS = 10
export(Texture)var primaryFirePattern
export(int)var primaryAmmoStash = 60
export(int)var primaryAmmoClip = 30
export(int)var primaryClipSize = 30
export(int)var primaryPelletCount = 1
export(NodePath)var _animationTree;
export(String)var animationPropertyReload;
export(String)var animationPropertyFire;
export(String)var animationPropertyTimeScale
export(String)var animationPropertyReloadDone
export(String)var animationPropertyGunEmpty
export(String)var animationPropertyReloadCancel
export(float)var fireAnimLength;
export(NodePath)var _raycast;
export(PackedScene)var debug;
export(float)var spread = 0.3
export(AudioStreamSample)var pFireEffect

onready var raycast:RayCast = get_node(_raycast)
var animationTree;
var firePattern:Dictionary
var firePatternIndex = 0
var fireDone = true;
var reloadDone = true;
var hitpoints:Array
var timer = 0;
var gunReady = false
var audioStreamPool:Array
var freeAudioStreams:Array
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

func _ready():
	self.generateFirePattern()
	animationTree=get_node(_animationTree)

func canReload():
	return (self.primaryAmmoClip < self.primaryClipSize) and self.primaryAmmoStash > 0 and fireDone and reloadDone and gunReady;

func spendBullet():
	if self.primaryAmmoClip <= 1:
		animationTree.set(animationPropertyGunEmpty, true)
	else:
		animationTree.set(animationPropertyGunEmpty, false)
	if self.primaryAmmoClip > 0:
		self.primaryAmmoClip-=1;
		return true
	return false
func canFire():
	return self.primaryAmmoClip > 0 and fireDone and reloadDone and gunReady
func castBullet(var direction, var length):
	print("CASTING TO ", direction, " * ", length, " = ", raycast.cast_to)
	raycast.cast_to = direction * length
	raycast.force_raycast_update()
	hitpoints.push_back(raycast.get_collision_point())
	var newball = debug.instance();
	get_tree().current_scene.add_child(newball);
	newball.global_transform.origin = raycast.get_collision_point()
func fireBullet():
	animationTree.active = true
	if(canFire()):
		playSFX(self.pFireEffect)
		animationTree.set(animationPropertyFire,true)
		animationTree.set(animationPropertyTimeScale,primaryRPS*fireAnimLength)
		fireDone = false;
		spendBullet();
		
		for i in range(0,primaryPelletCount):
			var seek = 0;
			for part in firePattern:
				if seek < firePatternIndex:
					seek +=1;
				else:
					castBullet((Vector3(firePattern[part].x*spread,firePattern[part].y*spread,1)).normalized(), 100);
					firePatternIndex+=1
					break
			if firePatternIndex >= firePattern.size():
				firePatternIndex = 0;
	elif reloadDone == false:
		animationTree.set(animationPropertyReloadCancel,true)

func fireAnimFinished():
	self.fireDone = true;
	animationTree.set(animationPropertyFire,false)
	animationTree.set(animationPropertyTimeScale,1)
func putBulletsInClip(amount):
	if amount < 0:
		amount = self.primaryClipSize
	amount = clamp(amount, 0, self.primaryClipSize - self.primaryAmmoClip)
	amount = clamp(amount, 0, self.primaryAmmoStash)
	self.primaryAmmoClip += amount
	self.primaryAmmoStash -= amount
	if primaryAmmoClip >= primaryClipSize:
		animationTree.set(animationPropertyReloadDone,true)


func fireAnimReloadFinished():
	self.reloadDone = true;

	animationTree.set(animationPropertyReload,false)
	animationTree.set(animationPropertyReloadDone,false)
	animationTree.set(animationPropertyReloadCancel,false)
	timer = 99999

func reload():
	if canReload():
		animationTree.set(animationPropertyReloadCancel,false)
		animationTree.set(animationPropertyReload,true)
		reloadDone = false
func _process(delta):
	if Input.is_action_pressed("pFire") and timer > (1/self.primaryRPS):
		fireBullet()
		timer = 0
	if Input.is_action_just_released("pFire"):
		self.firePatternIndex=0
	if Input.is_action_pressed("reload"):
		reload()
	timer += delta

func fireAnimDrawFinished():
	gunReady = true

func playSFX(var sfx):
	if audioStreamPool.size() <=0:
		#populate pool
		for i in range(0,20):
			var player := AudioStreamPlayer3D.new()
			add_child(player)
			player.global_transform.origin = self.global_transform.origin
			player.bus = "weapons"
			player.connect("finished", self, "repopulateFreeAudioList")
			audioStreamPool.push_back(player);
			repopulateFreeAudioList()
	if freeAudioStreams.size()>0:
		var stream:AudioStreamPlayer3D = freeAudioStreams[0]
		stream.stream = sfx
		stream.play()
		freeAudioStreams.remove(0)
	
	

	
func repopulateFreeAudioList():

	for c in range(0, audioStreamPool.size()):
		if audioStreamPool[c].playing == false:
			freeAudioStreams.push_back(audioStreamPool[c])

