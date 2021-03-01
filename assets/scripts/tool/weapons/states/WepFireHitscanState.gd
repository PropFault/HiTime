extends WepFireState
class_name WepFireHitscanState
export(PackedScene)var debug
export(float)var hitscanRange
func _fireProjectile(var dir):
	self.owningTool.raycast.cast_to = dir * hitscanRange
	self.owningTool.raycast.force_raycast_update()
	var newball = debug.instance();
	get_tree().current_scene.add_child(newball);
	newball.global_transform.origin = self.owningTool.raycast.get_collision_point()
