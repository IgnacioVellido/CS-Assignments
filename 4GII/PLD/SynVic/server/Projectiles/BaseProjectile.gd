extends KinematicBody

class_name BaseProjectile

signal despawn # Emited when the projectile despawns and stops existing

#===============================================================================

var timer = 0
var despawnTime = 5

export var damage : int = 50

var speed : float # How quickly the projectile moves
var direction : Vector3 # A vector with module 1 that sets the projectile's direction

# Team of the player who shot the projectile
var team : String

puppet var puppet_pos

# Buffs and Debuffs
# When the projectile hits a player of the opposite team, it applies the debuff
# to him

var status_slowness = false # Moves more slowly
var status_slowness_intensity:float
var status_slowness_duration

var status_vulnerability = false # Receives more damage
var status_vulnerability_intensity:float
var status_vulnerability_duration

var status_tickdmg = false # Receives damage periodically
var status_tickdmg_intensity:float
var status_tickdmg_duration
var status_tickdmg_period

#===============================================================================

func _process(delta):
	timer += delta
	if timer > despawnTime:
		rpc("despawn")
		timer = 0

func _physics_process(delta):
	# Move following velocity vector
	var collision = move_and_collide(direction * speed * delta)
	
	# If the projectile collides, it calls the function on_collision
	if collision:
		on_collision(collision)
		
	rset_unreliable("puppet_pos", translation)

#===============================================================================

# Function to be called when the projectile collides.
# The standard behaviour is to disappear
# warning-ignore:unused_argument
func on_collision(collision):
	# Make it do damage by default ???
	var body = collision.get_collider()
	damage_enemies([body])
	
	# Apply debuffs
	apply_debuffs(body)
	
	# Disappear
	rpc("despawn")

remotesync func despawn():
	emit_signal("despawn")
	queue_free()

#===============================================================================

func damage_enemies(bodies):
	for body in bodies:
		# Check if body is in the enemy team		
		if (team == "team_1" and body.is_in_group("team_2")) or \
		 (team == "team_2" and body.is_in_group("team_1")):
			body.on_hit(damage)

#===============================================================================

# Functions to set the collision layers and masks
# They receive as argument a list of integers, referring to the layers/masks
# to set. The others are not set.
# Layers (input of these functions) start at 1, whereas bits start at 0.

func set_collision_layer_from_list(layers):
	var arg : int = 0
	
	for layer in layers:
		arg += pow(2, layer-1)
		
	self.set_collision_layer(arg)
	
func set_collision_mask_from_list(layers):
	var arg : int = 0
	
	for layer in layers:
		arg += pow(2, layer-1)
		
	self.set_collision_mask(arg)

#===============================================================================
# Buffs and Debuffs

func apply_slowness(intensity, duration=-1):
	status_slowness = true
	status_slowness_intensity = intensity
	status_slowness_duration = duration
	
func apply_vulnerability(intensity, duration=-1):
	status_vulnerability = true
	status_vulnerability_intensity = intensity
	status_vulnerability_duration = duration
	
func apply_tickdmg(intensity, duration=-1, period=1):
	status_tickdmg = true
	status_tickdmg_intensity = intensity
	status_tickdmg_duration = duration
	status_tickdmg_period = period


func refresh_slowness():
	pass

func refresh_vulnerability():
	pass

func refresh_tickdmg():
	pass

# Apply debuffs to a body it has collided with
func apply_debuffs(body):
	# If is not an obstacle
	if not body.is_in_group("obstacle"):
		if status_slowness:
			body.apply_slowness(status_slowness_intensity, status_slowness_duration)
		if status_vulnerability:
			body.apply_vulnerability(status_vulnerability_intensity, status_vulnerability_duration)
		if status_tickdmg:
			body.apply_tickdmg(status_tickdmg_intensity, status_tickdmg_duration, status_tickdmg_period)
