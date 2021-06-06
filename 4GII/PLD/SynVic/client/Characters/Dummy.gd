extends KinematicBody

class_name Dummy

#===============================================================================
# JUST FOR TESTING PURPOSES!
# This scenes serves as a dummy to test the player's abilities onto.
# It cannot move (for now). It has health. When its health is depleted,
# it respawns.
#===============================================================================

export var max_health : int = 1000
var health : int

# When the dummy respawns, it changes color
var possible_colors = [Color(1.0, 0.0, 0.0, 1.0), Color(0.0, 1.0, 0.0, 1.0), Color(0.0, 0.0, 1.0, 0.0)]
var curr_color = 2 # Index in possible_colors

#===============================================================================

func _ready():
	respawn()

#===============================================================================

func on_hit(damage):
	health -= damage
	print("Health:", health)
	
	if health <= 0:
		respawn()

#===============================================================================

# If the dummy is destroyed, it respawns again but with a different color
func respawn():
	health = max_health
	
	curr_color = (curr_color + 1) % len(possible_colors)
	
	# Change albedo to next color in possible_colors
	$MeshInstance.get_surface_material(0).set_albedo(possible_colors[curr_color])

#===============================================================================
