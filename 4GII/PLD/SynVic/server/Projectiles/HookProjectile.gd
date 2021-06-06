extends BaseProjectile

class_name HookProjectile

#===============================================================================
# Projectile that if collides moves character to its position.
#===============================================================================

signal moveTo(trans)    # trans = transform of the projectile
	
#===============================================================================

# Function to be called when the projectile collides.
# The standard behaviour is to disappear
# warning-ignore:unused_argument
func on_collision(collision):	
	.on_collision(collision)	# Despawn and do damage in parent class
	emit_signal("moveTo", transform)
