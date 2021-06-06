extends KinematicBody
 
class_name BaseCharacter # Base class all different characters must inherit from 

signal died # Emitted when the player dies and respawn.

onready var mesh = $MeshInstance

# ------------------------------------------------------------------------------
# Generic character stats

# Health
var max_health : int
puppet var health : int
var healthRegeneration = 0

# Speed
var speed # Speed of the character's movement

# Range
var basicRange = 0

# Cooldowns
const Cooldown = preload('res://Utilities/Cooldown.gd')
var cooldownBasic = 0
var cooldownSkill1 = 0
var cooldownSkill2 = 0
var cooldownSkill3 = 0
var cooldownUltimate = 0
var cooldownCasting # Cooldown used to immobilize the player while skills 1-3 are being casted 

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

var listenToBasic = true
var listenToSkill1 = true
var listenToSkill2 = true
var listenToSkill3 = true
var listenToUltimate = true

# Movement
# Movement State. 0 -> idle, 1 -> moving to a point,
# 2 -> chases its target and attacks if it gets close enough
puppet var movement_state : int = 0
var movement_target = null # Node
puppet var movement_target_name = null # Only used when movement_state = 2

# Dash
var dash_target_position
var dash_speed
var dash_direction

# For pathfinding
var path = []
var path_ind = 0
onready var nav = $"../../Navigation"

# Mouse Position (raycasted onto the floor). This way, I don't need to
# perform raycasting
var curr_mouse_pos

#===============================================================================

# Team 
# Every player is either in team_1 or team_2, depending on which group the node is in.
var team : String
var enemy_team : String
onready var team_colors = {"team_1": Color(0,0,1,1), "team_2": Color(1,0,0,1)}
var player_name : String

# Spawn position
# <Temporary> For now, it is equal to its starting position
var spawn_pos = Vector3(0,0.8,0)

# Networking position variables
puppet var puppet_pos
puppet var puppet_rot

#===============================================================================

func set_team(my_team):
	# Assign group
	add_to_group(my_team)
	team = my_team
	enemy_team = "team_1" if team == "team_2" else "team_2"

func _ready():
	# Notify the stage when it dies	
	self.connect("died", get_tree().get_root().get_node("Stage"), "player_died")
	
	puppet_pos = spawn_pos
	puppet_rot = rotation
	
	# Make meshInstance material unique (not shared with other instances)
	mesh.set_surface_material(0, mesh.get_surface_material(0).duplicate())
	mesh.get_surface_material(0).set_albedo(team_colors[team])
	
	# Collision layers
	if team == "team_1":
		self.set_collision_layer_bit(0,1)
#		self.set_collision_mask_bit(10, 1024)
		self.set_collision_mask_bit(1, 2)
		self.set_collision_mask_bit(2, 4)
		self.set_collision_mask_bit(4, 16)
	else:
		self.set_collision_layer_bit(1,2)
#		self.set_collision_mask_bit(0, 1)
		self.set_collision_mask_bit(2, 4)
		self.set_collision_mask_bit(3, 8)

#===============================================================================

func _process(delta):
	# Cooldowns
	cooldownBasic.tick(delta)
	cooldownSkill1.tick(delta)
	cooldownSkill2.tick(delta)
	cooldownSkill3.tick(delta)
	cooldownUltimate.tick(delta)

	# Casting
	if status_casting:
		cooldownCasting.tick(delta)

		# Casting time has ended
		if cooldownCasting.check():
			end_casting()

#===============================================================================
 
func _physics_process(delta):
	if status_dashing:
		dash(delta)
	elif status_immobilized or status_onCC:
		pass
	else:
		move(delta)
	
	rset_unreliable("puppet_pos", translation)
	rset_unreliable("puppet_rot", rotation)

#===============================================================================
# Walking
#===============================================================================

func move(delta):
	match movement_state:
		# Idle -> the character doesn't move
		0 : 
			pass
		# Follows the path
		1 :
			if path_ind < path.size():
				walk_path(delta)
			else:
				# If the path is finished, the player stops moving
				movement_state = 0
		# Chases the target and attacks it if its close enough
		2 :
			# If the target is within range, the character attacks it and stops moving
			# TODO: Optimize, don't check each time
			movement_target = get_node("../" + movement_target_name)
			var dist_to_target = (movement_target.translation - self.translation).length()
			
			if dist_to_target <= basicRange:
				rpc("basic_skill", movement_target)
				movement_state = 0
			# A new path is made
			# TODO: optimization (don't make a new path if it's not needed)
			else:
				calculate_path(movement_target.translation)
				walk_path(delta)

# Walk next section of the path
func walk_path(delta):
	# If the current section of the path is shorter than this distance,
	# the next section is followed
	var threshold_dist = 0.2 # Modify this based on the character speed
	
	var move_vec = (path[path_ind] - translation)
	
	# Rotate the player to match the direction of move_vec
	var angle = atan2(move_vec[0], move_vec[2])
	if abs(move_vec[2]) > 0.005 or (move_vec[0]) > 0.005:
		rotation.y = angle
	
	if move_vec.length() < threshold_dist: # Now it walks the next section of the path
		path_ind += 1
	
	if path_ind < path.size():
		move_vec = (path[path_ind] - translation)
		
		var movement_speed = speed
		if status_slowness:
			movement_speed = movement_speed * 0.7 
		
		move_and_collide(move_vec.normalized() * movement_speed * delta)

# Find the path from current position to target_pos
func calculate_path(target_pos):
	path = nav.get_simple_path(translation, target_pos)
	path_ind = 0
	
# Delete current path and stop the player	
func stop():
	path = []
	path_ind = 0
	
#===============================================================================
# Inputs
#===============================================================================

sync func input_click(click_position):
	if not status_onCC:
		calculate_path(click_position)
		curr_mouse_pos = click_position
		movement_state = 1 # Walk to that position

#===============================================================================
# Dashing
#===============================================================================

# During the dash the character cannot collide (partially intended, it should 
# collide with objects different than terrain)
func dash(delta):
	# If we arrived
	if transform.origin.distance_to(dash_target_position) < 1:
		rpc("endDash")
	else:
		move_and_collide(dash_direction.normalized() * dash_speed * delta)

remotesync func endDash():
	status_dashing = false
	$CollisionShape.disabled = false
	
	if status_casting:
		end_casting()

#===============================================================================
# Skills
#===============================================================================

# These are going to be overwritten by each character, put here only generic
# functionality

# - Skills -
func basic_skill(enemy):	
	pass

func skill_1(position):
	pass

func skill_2(position):
	pass

func skill_3(position):
	pass

func ultimate_skill(position):
	pass

# - Casting -

# Called when the player is casting a skill and cannot interact while it is being casted
func cast(time):
	cooldownCasting.set_max_time(time)
	cooldownCasting.begin()
	
	status_casting = true
	
	# The player cannot interact while it is casting
	stop()
	
	status_immobilized = true
	listenToBasic = false
	listenToSkill1 = false
	listenToSkill2 = false
	listenToSkill3 = false
	listenToUltimate = false
	
# Called after cooldownCasting is ready
func end_casting():
	print("End casting")
	status_casting = false
	
	# The player can interact again
	status_immobilized = false
	listenToBasic = true
	listenToSkill1 = true
	listenToSkill2 = true
	listenToSkill3 = true
	listenToUltimate = true
	
#===============================================================================
# Damage
#===============================================================================

# The player receives damage
func on_hit(damage):
	rset("health", health-damage)
	
	print("Health:", health)
	
	if health <= 0:
		respawn()


# The player respawns
func respawn():
	print("Player respawned")
	rset("health", max_health)
	
	translation = spawn_pos
	
	# Notify the stage a player has died
	emit_signal("died", team)

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

func apply_onCC(duration=-1):
	status_onCC_duration = duration
	
	# Remove previous timer (if existed)
	if status_onCC_timer != null:
		status_onCC_timer.queue_free()
		status_onCC_timer = null
	
	# Add new timer
	if duration != -1:
		status_onCC_timer = Timer.new()
		self.add_child(status_onCC_timer)
		status_onCC_timer.connect("timeout", self, "remove_onCC")
		status_onCC_timer.start(duration)
		
	status_onCC = true

func remove_onCC():
	# Remove timer (if existed)
	if status_onCC_timer != null:
		status_onCC_timer.queue_free()
		status_onCC_timer = null
		
	status_onCC = false
