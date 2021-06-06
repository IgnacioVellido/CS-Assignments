extends BaseProjectile

class_name BouncingProjectile

#===============================================================================
# Projectile that bounces a number of times and explodes.
# It also explodes if collides with an enemy, damaging in an area.
#===============================================================================

var max_bounces = 3
var actual_bounces = 0

# SFX
onready var sound_player = $SoundPlayer

#===============================================================================

func _init():
	despawnTime = 20

func _ready():
	# Set the child node collision layer/mask to the one of the parent
	$Explosion.collision_mask = self.collision_mask
	$Explosion.collision_layer = self.collision_layer

#===============================================================================

# Explode doing damage to all enemies in a radius
remotesync func explode():
	var bodies = $Explosion.get_overlapping_bodies()
	damage_enemies(bodies)
	
	# Play SFX
	# NO FUNCIONA!
	sound_player.play()
	
	# The projectile despawns
	rpc("despawn")
