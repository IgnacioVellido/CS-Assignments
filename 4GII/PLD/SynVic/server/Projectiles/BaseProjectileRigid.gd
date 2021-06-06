# Projectile is a rigid body, therefore it will exist even when the player dies
# Being a RigidBody let us interact with other objects more easily 
extends RigidBody

class_name BaseProjectileRigid

var timer = 0
const DESPAWN_TIME = 2

export var damage : int = 20
#var effects 

#===============================================================================

# Called when the node enters the scene tree for the first time.
func _ready():	
	# Needed for detecting collisions
	set_contact_monitor(true)
	set_max_contacts_reported( 1 ) 
	
#===============================================================================

func _process(delta):
	timer += delta
	if timer > DESPAWN_TIME:
		queue_free()
		timer = 0

#===============================================================================

func _physics_process(delta):
	# Detect collisions
	var bodies = get_colliding_bodies()

	for curBody in bodies:
		if curBody.is_in_group("enemies"):
			# If the projectile has hit an enemy, it does dmg to it
			curBody.on_hit(damage)
	
	# The projectile disappears after hitting anything
	if len(bodies) > 0:
		queue_free()
