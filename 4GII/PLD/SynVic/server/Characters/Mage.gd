extends BaseCharacter

class_name Mage

#===============================================================================

var ally # The other member in its team

# Variables for the basic skill
export var basic_damage: int = 5
export var autoattack_slowness_intensity:float = 0.7
export var autoattack_slowness_duration = 5

# Variables for the Q skill
var area_of_effect = preload("res://Areas/AreaOfEffect.tscn")
export var area_duration:int = 4 # After this time, it disappears
export var area_size = 6

# Variables for the E skill
var wall = preload("res://Walls/MageWall.tscn")
var wall_begin_pos # Positions for the wall
var wall_end_pos
export var min_wall_length = 3 # Minimum distance between wall_begin_pos and wall_end_pos
export var max_wall_length = 15 # Maximum distance between wall_begin_pos and wall_end_pos
var casting_e = false # True if the player is in the process of casting a wall
var last_wall # Reference to the last wall the mage has built.
var last_wall_name = 0

# Variables for the R skill
var status_casting_R = false
var R_casting_time = 3
export var R_CC_duration = 5 # (For the enemies)
export var R_area_size = 15 # Area the enemies must be in at the end of the casting to be stunned

#===============================================================================

func _ready():
	# Initializing stats
	max_health = 400
	health = max_health
	speed = 15
	healthRegeneration = 0
	basicRange = 6
	
	# Cooldowns
	cooldownBasic = Cooldown.new(2)
	cooldownSkill1 = Cooldown.new(7)
	cooldownSkill2 = Cooldown.new(15)
	cooldownSkill3 = Cooldown.new(5)
	cooldownUltimate = Cooldown.new(30)
	cooldownCasting = Cooldown.new(1)

func _process(delta):
	._process(delta)
	
	if not ally:
		set_ally()

func set_ally():
	# Get ally
	for player in get_tree().get_nodes_in_group(team):
		if player != self:
			ally = player

#===============================================================================
# - Skills -
#===============================================================================

# Uses his staff to perform a close-range attack which uses the ice element to apply
# the slowness debuf to the enemy

remotesync func basic_skill(enemy):
	if cooldownBasic.is_ready():
		# We know the character is in range
		
		# Apply damage
		enemy.on_hit(basic_damage)
		
		# Apply frozen debuff for 5 seconds
		enemy.apply_slowness(autoattack_slowness_intensity, autoattack_slowness_duration)

#-------------------------------------------------------------------------------
# Invokes a random element on a zone of the map

remotesync func skill_1(position):
	.skill_1(position) # We will probably make some code in the super class
	
	if cooldownSkill1.is_ready():
		#	Destroy old area
		var area_name = "Area_" + self.name
		var old_area = get_node("/root/Stage/" + area_name)
		if old_area:
			old_area.disappear()
		
		# Choose a random debuff in {vulnerability, tickdmg, slowness}
		var possible_status = ["slowness", "vulnerability", "tickdmg"]
		randomize()
		var chosen_status = possible_status[randi() % 3]
		
		areaSpawner.rpc("spawn_Area", self.name,
				position, team, area_duration, area_size, chosen_status)
	
		# Stop casting e (if casting was in progress)
		casting_e = false
		
#-------------------------------------------------------------------------------
# Interchanges its position with its ally

remotesync func skill_2(position):
	.skill_2(position) # We will probably make some code in the super class
	
	if cooldownSkill2.is_ready():
		# Interchange position
		var ally_pos = ally.get_translation()
		ally.set_translation(self.get_translation())
		self.set_translation(ally_pos)
		
		# Stop both players
		ally.stop()
		self.stop()
		
		# Stop casting e (if casting was in progress)
		casting_e = false

#-------------------------------------------------------------------------------
# Creates a wall

remotesync func skill_3(position):
	.skill_3(position) # We will probably make some code in the super class
	
	if cooldownSkill3.check():
		if casting_e:
			# End casting
			casting_e = false
			cooldownSkill3.begin()
		else:
			casting_e = true

# Builds a wall given the two positions the player has clicked. If the wall
# cannot be built, it returns false.
puppet func build_wall(begin_pos, end_pos):
	var dir_vector = (end_pos - begin_pos).normalized()
	
	# Check if the wall would be too long
	if begin_pos.distance_to(end_pos) > max_wall_length: 
		end_pos = begin_pos + dir_vector*max_wall_length
		
	# Build a wall from begin_pos to end_pos
	var new_wall = wall.instance()
	# Important -> Different names
	new_wall.name = "Wall_" + self.name + "_" + String(last_wall_name+1)
	
	# Position (the middle point of the wall)
	var new_wall_pos = (begin_pos + end_pos) / 2
	new_wall_pos[1] = 1
	new_wall.set_translation(new_wall_pos)
	
	# Length
	var new_wall_length = begin_pos.distance_to(end_pos)
	new_wall.set_scale(Vector3(new_wall_length/2,2,1))
	
	# Rotation
	var reference_vector = Vector2(1,0)
	var dir_vector_2d = Vector2(dir_vector[0], dir_vector[2]).normalized()
	var rotation_angle = reference_vector.angle_to(dir_vector_2d)
	new_wall.set_rotation(Vector3(0,-rotation_angle,0))

	# Check if the wall overlaps any player
	var wall_overlaps_player = false
	var players = get_node("/root/Stage/Players").get_children()
	
	for p in players:
		if distance_from_wall_to_player(begin_pos, end_pos, p.translation) \
		   < 0:
			wall_overlaps_player = true
			
	# If the wall overlaps a player, don't create it
	if wall_overlaps_player:
		new_wall.free()
	else:
		get_node("../..").add_child(new_wall)
		last_wall_name += 1

# Calculates the approximate distance from the wall to the player
func distance_from_wall_to_player(wall_beginPos, wall_endPos, player_pos,
								  wall_width = 0.6, player_width = 0.8):
	var distance
	
	# <Check if player_pos's perpendicular line to the wall_rect
	# falls inside the wall or outside>
	
	# Calculate general equation of the wall's line: ax + by + c = 0
	var p_0 = Vector2(wall_beginPos[0], wall_beginPos[2])
	var p_1 = Vector2(wall_endPos[0], wall_endPos[2])
	var p_2 = Vector2(player_pos[0], player_pos[2])
	
	var a = -p_0[1] + p_1[1]
	var b = -p_1[0] + p_0[0]
	var c = p_0[1]*p_1[0] - p_0[0]*p_1[1]
	
	# Calculate general equation of the perpendicular line to the wall's line
	# which goes through player_pos (p_2)
	var a_p = -b
	var b_p = a
	var c_p = -a_p*p_2[0] - b_p*p_2[1]
	
	# Calculate intersection of both lines
	var i_x = (b*c_p - b_p*c) / (a*b_p - a_p*b)
	var i_y = (a*c_p - a_p*c) / (a_p*b - a*b_p)
	var p_i = Vector2(i_x, i_y)
	
	# Calculate distance from the furthest point of the wall to p_i
	var d_i = max(p_i.distance_to(p_0), p_i.distance_to(p_1))
	
	# Check wheter p_i is on the wall segment or not (it's on the wall line)
	var d_w = p_0.distance_to(p_1)
	var p_i_inside_wall = d_i < d_w
	
	if p_i_inside_wall:
		# If the perpendicular falls into the wall segment, the distance
		# from the player to the wall is d(p_i, p_2)
		distance = p_2.distance_to(p_i)
	else:
		# If it falls outside the segment, the distance is the closest
		# distance from the ends of the wall to p_2
		distance = min(p_2.distance_to(p_0), p_2.distance_to(p_1))

	# Now substract the width of the player and wall
	distance -= wall_width + player_width
	
	return distance
	
#-------------------------------------------------------------------------------
# Charges for 4 seconds and on recasting throws a bullet, up a maximum of 10

remotesync func ultimate_skill(position):
	.ultimate_skill(position)
	
	if cooldownUltimate.check():
		# Start casting its ultimate
		# The player cannot move, act or interrupt the casting
		status_casting_R = true
		cast(5)
	
		# Stop casting e (if casting was in progress)
		casting_e = false

# Override method to execute the action of the R skill after its
# casting has finished
func end_casting():
	.end_casting()
	rpc("end_casting_R")

remotesync func end_casting_R():
	# The player was casting its ultimate
	if status_casting_R:
		print("BOOM")
		status_casting_R = false
		
		# Stun every enemy player in an area
		var enemies
		
		if team == 'team_1':
			enemies = get_tree().get_nodes_in_group('team_2')
		else:
			enemies = get_tree().get_nodes_in_group('team_1')
			
		for e in enemies:
			# Check if it's close enough
			var distance = translation.distance_to(e.translation)
			
			if distance <= R_area_size:
				e.apply_onCC(R_CC_duration)
				
		cooldownUltimate.begin()
