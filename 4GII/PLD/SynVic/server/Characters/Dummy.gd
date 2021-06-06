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

# Status effects ------------------------

# Slowness
var status_slowness = false     # Moves more slowly
var status_slowness_intensity:float  # Number between 0 (cannot move) and 1 (no slowness)
var status_slowness_timer # Duration of slowness
var status_slowness_duration


# Vulnerability
var status_vulnerability = false # Receives more damage
var status_vulnerability_intensity:float = false # Number between 1 (receives the same dmg) and infinite (receives infinite dmg)
var status_vulnerability_timer # Duration of vulnerability
var status_vulnerability_duration

# Tick damage
var status_tickdmg = false # Receives damage periodically
var status_tickdmg_intensity:float = false # Number between 0 (receives no dmg) and infinite (receives infinite dmg)
var status_tickdmg_timer # Duration of tickdmg
var status_tickdmg_duration
var status_tickdmg_tick_timer # How often it receives the dmg
var status_tickdmg_refresh = false # If true, the effect will be refreshed after the next tick of dmg

# CC (stun)
var status_onCC = false         # Can't act nor move
var status_onCC_timer
var status_onCC_duration # Duration of the CC

var status_immobilized = false  # Can't move
var status_bleeding = false     # Loses health every frame
var status_untergatable = false # Can't collide or recieve any new damage
var status_invulnerable = false # Can't collide or suffer any damage
var status_dashing = false      # Can't collide with walls
var status_casting = false # True when the player is casting a skill 1-3

#===============================================================================

func _ready():
	# Connect input_event signal to engineer
	# It must be done by code since it passes self object as a parameter
	var players = get_node("..").get_children()
	for p in players:
		self.connect("input_event", p, "_on_Enemy_input_event", [self])
	
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

#===============================================================================
# Effects
#===============================================================================

# The player moves more slowly
# Duration == -1 means the debuff is infinite
func apply_slowness(intensity, duration=-1):
	status_slowness_duration = duration
	
	# Remove previous timer (if existed)
	if status_slowness_timer != null:
		status_slowness_timer.queue_free()
		status_slowness_timer = null
	
	# Add new timer
	if duration != -1:
		status_slowness_timer = Timer.new()
		self.add_child(status_slowness_timer)
		status_slowness_timer.connect("timeout", self, "remove_slowness")
		status_slowness_timer.start(duration)
		
	status_slowness = true
	status_slowness_intensity = intensity

# The debuff starts again	
func refresh_slowness():
	if status_slowness_timer != null:
		status_slowness_timer.start(status_slowness_duration)
	
func remove_slowness():
	# Remove timer (if existed)
	if status_slowness_timer != null:
		status_slowness_timer.queue_free()
		status_slowness_timer = null
		
	status_slowness = false
	
func apply_vulnerability(intensity, duration=-1):
	status_vulnerability_duration = duration
	
	# Remove previous timer (if existed)
	if status_vulnerability_timer != null:
		status_vulnerability_timer.queue_free()
		status_vulnerability_timer = null
	
	# Add new timer
	if duration != -1:
		status_vulnerability_timer = Timer.new()
		self.add_child(status_vulnerability_timer)
		status_vulnerability_timer.connect("timeout", self, "remove_vulnerability")
		status_vulnerability_timer.start(duration)
		
	status_vulnerability = true
	status_vulnerability_intensity = intensity

func refresh_vulnerability():
	if status_vulnerability_timer != null:
		status_vulnerability_timer.start(status_vulnerability_duration)

func remove_vulnerability():
	# Remove timer (if existed)
	if status_vulnerability_timer != null:
		status_vulnerability_timer.queue_free()
		status_vulnerability_timer = null
		
	status_vulnerability = false
	
func apply_tickdmg(intensity, duration=-1, period=1):
	status_tickdmg_duration = duration
	
	# Remove previous timers (if existed)
	if status_tickdmg_tick_timer != null:
		status_tickdmg_tick_timer.queue_free()
		status_tickdmg_tick_timer = null
	if status_tickdmg_timer != null:
		status_tickdmg_timer.queue_free()
		status_tickdmg_timer = null
	
	# Add new timers
	status_tickdmg_tick_timer = Timer.new()
	self.add_child(status_tickdmg_tick_timer)
	status_tickdmg_tick_timer.connect("timeout", self, "receive_tick_damage")
	status_tickdmg_tick_timer.start(period)
	
	if duration != -1:
		status_tickdmg_timer = Timer.new()
		self.add_child(status_tickdmg_timer)
		status_tickdmg_timer.connect("timeout", self, "remove_tickdmg")
		status_tickdmg_timer.start(duration)
		
	status_tickdmg = true
	status_tickdmg_intensity = intensity

func refresh_tickdmg():
	status_tickdmg_refresh = true
	
func remove_tickdmg():
	# Remove timers
	if status_tickdmg_tick_timer != null:
		status_tickdmg_tick_timer.queue_free()
		status_tickdmg_tick_timer = null
	
	if status_tickdmg_timer != null:
		status_tickdmg_timer.queue_free()
		status_tickdmg_timer = null
	
	status_tickdmg = false
	status_tickdmg_refresh = false
	
func receive_tick_damage():
	on_hit(status_tickdmg_intensity) # Affected by vulnerability debuff!!
	
	# Check if the effect must be refreshed
	if status_tickdmg_refresh and status_tickdmg_timer != null:
		status_tickdmg_refresh = false
		status_tickdmg_timer.start(status_tickdmg_duration)
