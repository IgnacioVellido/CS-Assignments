extends BaseProjectile

class_name PierceProjectile

#===============================================================================
# Projectile that pierce through enemies and terrain
#===============================================================================
	
func _init():
	despawnTime = 3
	damage = 30
	
func _ready():
	# Set the child node collision layer/mask to the one of the parent
	$Area.collision_mask = self.collision_mask
	$Area.collision_layer = self.collision_layer

#===============================================================================

func _on_Area_body_entered(body):
	print("Choque")
	damage_enemies([body])
