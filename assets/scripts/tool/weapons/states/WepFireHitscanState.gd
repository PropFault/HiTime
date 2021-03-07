extends WepFireState
class_name WepFireHitscanState
export(PackedScene)var debug
export(float)var hitscanRange
var init = false
func onHit(var point, var collider, var damage):
	print("HIT ", point, " for ", damage)
	var newball = debug.instance();
	get_tree().current_scene.add_child(newball);
	newball.global_transform.origin = self.owningTool.raycast.get_collision_point()
	if collider != null:
		if "hp" in collider:
			collider.hp -=damage
		if collider is RigidBody:
			var body = collider as RigidBody
			body.apply_impulse(self.owningTool.raycast.get_collision_point() - body.global_transform.origin, (self.owningTool.raycast.get_collision_point() - self.owningTool.raycast.global_transform.origin).normalized() * 25)


func _fireProjectile(var dir):
	if not init:
		self.owningTool.raycast.connect("onHit", self, "onHit")
		init = true
	self.owningTool.raycast.fire(dir,500,10, 0.01)

