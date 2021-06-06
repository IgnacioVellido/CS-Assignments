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

#===============================================================================

func _ready():
	puppet_pos = translation

func _process(delta):
	timer += delta
	if timer > despawnTime:
		despawn()

func _physics_process(delta):
	translation = puppet_pos

#===============================================================================

# Function to be called when the projectile collides.
# The standard behaviour is to disappear
func on_collision(collision):
	pass

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
