extends BaseProjectile

class_name BouncingProjectile

#===============================================================================
# Projectile that bounces a number of times and explodes.
# It also explodes if collides with an enemy, damaging in an area.
#===============================================================================

var max_bounces = 3
var actual_bounces = 0

#===============================================================================

func _init():
	despawnTime = 20

func _ready():
	# Set the child node collision layer/mask to the one of the parent
	$Explosion.collision_mask = self.collision_mask
	$Explosion.collision_layer = self.collision_layer

#===============================================================================

# Function to be called when the projectile collides.

func on_collision(collision):
	var body = collision.get_collider()
	
	# If it collides with an enemy, it explodes
	if (team == "team_1" and body.is_in_group("team_2")) or \
	   (team == "team_2" and body.is_in_group("team_1")):
		rpc("explode")
	else: # If it collides with a part of the scenario, it bounces
		actual_bounces += 1
		
		if actual_bounces > max_bounces: # If it has reached the maximum number of bounces, it explodes
			rpc("explode")
		else: # It bounces
			direction = direction.bounce(collision.normal)
			direction[1] = 0

#===============================================================================

# Explode doing damage to all enemies in a radius
# SHOULD NOT COMPUTE IF NOT RESPONSIBLE OF THE OBJECT, UPDATE THE HEALTH IN PROCESS
remotesync func explode():
	var bodies = $Explosion.get_overlapping_bodies()
	damage_enemies(bodies)
	
	# The projectile despawns
	rpc("despawn")
