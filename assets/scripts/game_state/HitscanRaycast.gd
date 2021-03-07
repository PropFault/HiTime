extends RayCast
class_name HitscanRaycast
signal onHit(point,collider, damage)

func fire(var dir, var length, var damage, var damageFalloffModifier):
	self.cast_to = dir * length
	self.force_raycast_update()
	var point = self.get_collision_point()
	var distance = (point-self.global_transform.origin).length()
	damage = damage/(distance*damageFalloffModifier)
	emit_signal("onHit", point, self.get_collider(), damage)
	
