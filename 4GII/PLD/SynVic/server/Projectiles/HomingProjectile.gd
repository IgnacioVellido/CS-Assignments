extends BaseProjectile

class_name HomingProjectile

#===============================================================================
# Projectile that follows a target.
# In each physics_process call, its velocity vector is re-directed.
#===============================================================================

var target # Object the projectile is following

#===============================================================================

func _init():
	damage = 10

func _physics_process(delta):
	# Change direction to follow target
	direction = (target.translation - self.translation).normalized()
	._physics_process(delta)
