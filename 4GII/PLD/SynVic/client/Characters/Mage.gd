extends BaseCharacter

class_name Mage

#===============================================================================

# Variables for the basic skill
export var basic_damage:int = 5
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
var ultimate_sfx_scene = preload("res://SFX/MageCastingUltimateEffect.tscn") # Special Effect used for the casting
var ultimate_sfx
var ultimate_sfx_progress_texture # Texture which gets larger as the ultimate is being casted
var sfx_progression_cd # Timer used to display the progression of the SFX of the ultimate
var sfx_shine_offset = 0.5 # How big the small circle starts. This accounts for the delay between client and server.
var sfx_shine_threshold = 0.8 # When the casting progress is above this threshold, the texture begins to shine
var sfx_shine_energy = 0.4 # Emission energy for the material

# Sound Effects (SFX)
var basic_cast_sfx = preload("res://Audio/SFX/Mage/basic_cast.wav")
var q_cast_sfx = preload("res://Audio/SFX/Mage/q_cast.wav")
var w_cast_sfx = preload("res://Audio/SFX/Mage/w_cast.wav")
var e_cast_sfx = preload("res://Audio/SFX/Mage/e_cast.wav")
var r_cast_sfx = preload("res://Audio/SFX/Mage/r_cast.wav")
var r_stun_sfx = preload("res://Audio/SFX/Mage/r_stun.wav")

#===============================================================================

func _ready():
	# Initializing stats
	max_health = 400
	health = max_health
	healthRegeneration = 0
	basicRange = 6
	
	# Cooldowns
	cooldownBasic = Cooldown.new(2)
	cooldownSkill1 = Cooldown.new(7)
	cooldownSkill2 = Cooldown.new(15)
	cooldownSkill3 = Cooldown.new(5)
	cooldownUltimate = Cooldown.new(30)
	
	# Create Mage's Ultimate SFX from the beginning, but don't show it
	sfx_progression_cd = Cooldown.new(R_casting_time)
	
	# Show SFX
	ultimate_sfx = ultimate_sfx_scene.instance()
	ultimate_sfx_progress_texture = ultimate_sfx.get_child(0)
	
	ultimate_sfx.scale = Vector3(R_area_size,0.01,R_area_size)
	
	ultimate_sfx.hide()
	add_child(ultimate_sfx)

func _process(delta):
	._process(delta)
	
	# If it's casting its ultimate, display the corresponding SFX
	if status_casting_R:
		sfx_progression_cd.tick(delta)
		
		var time_left_perc = (sfx_progression_cd.time - sfx_shine_offset) \
							 / float(R_casting_time)
		var show_perc = 1 - time_left_perc
		
		# The texture gets bigger as the ultimate is being casted
		ultimate_sfx_progress_texture.scale = Vector3(show_perc,1,show_perc)
		
		# When it is about to be casted, it begins to shine
		if show_perc >= sfx_shine_threshold:
			ultimate_sfx_progress_texture.get_surface_material(0).set_emission_energy(sfx_shine_energy)

#===============================================================================
# - Skills -
#===============================================================================

# Uses his staff to perform a close-range attack which uses the ice element to apply
# the slowness debuf to the enemy

func basic_skill(enemy):
	# Play SFX
	if cooldownBasic.check():
		play_sfx(basic_cast_sfx)

#-------------------------------------------------------------------------------
# Invokes a random element on a zone of the map

remotesync func skill_1(position):
	.skill_1(position) # We will probably make some code in the super class
	
	# Play SFX
	if cooldownSkill1.check():
		play_sfx(q_cast_sfx)
	
	if cooldownSkill1.is_ready():
		# Stop casting e (if casting was in progress)
		casting_e = false

#-------------------------------------------------------------------------------
# Interchanges its position with its ally

remotesync func skill_2(position):
	.skill_2(position) # We will probably make some code in the super class
	
	# Play SFX
	if cooldownSkill2.check():
		play_sfx(w_cast_sfx)
	
	if cooldownSkill2.is_ready():
		# Stop casting e (if casting was in progress)
		casting_e = false

#-------------------------------------------------------------------------------
# Creates a wall

remotesync func skill_3(position):
	.skill_3(position) # We will probably make some code in the super class
	
	if is_network_master() and cooldownSkill3.check():
		if casting_e: # Build the wall
			# Store second point for the wall (unless it's too close to the first one)
			wall_end_pos = curr_mouse_pos
			
			# Make sure the wall isn't too small
			if wall_end_pos.distance_to(wall_begin_pos) >= min_wall_length:
				# Build Wall
				build_wall(wall_begin_pos, wall_end_pos)
				
				# Play SFX
				play_sfx(e_cast_sfx)
				
				# End casting
				casting_e = false
				
				# Deselect skill (change hud texture)
				if hud != null:
					hud.deselect_skill(3)
				
				cooldownSkill3.begin()
		else: # Store first point for the wall
			casting_e = true
			wall_begin_pos = curr_mouse_pos
			
			# Select skill (change hud texture)
			if hud != null:
				hud.select_skill(3)

# Builds a wall given the two positions the player has clicked. If the wall
# cannot be built, it returns false.
remote func build_wall(begin_pos, end_pos):
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
	new_wall.set_network_master(1)
	
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
		# Allow the player to move when clicking on the wall
		if is_network_master():
			new_wall.get_node("StaticBody").connect("input_event", self, "_on_Map_input_event")
		
			# Destroy old wall
			if last_wall != null:
				last_wall.delete()
			
			# Store reference to the new_wall
			last_wall = new_wall
		
			rpc("build_wall", begin_pos, end_pos)
			
		get_node("../..").add_child(new_wall)
		last_wall_name += 1

# Calculates the approximate distance from the wall to the player
func distance_from_wall_to_player(wall_begin_pos, wall_end_pos, player_pos,
								  wall_width = 0.6, player_width = 0.8):
	var distance
	
	# <Check if player_pos's perpendicular line to the wall_rect
	# falls inside the wall or outside>
	
	# Calculate general equation of the wall's line: ax + by + c = 0
	var p_0 = Vector2(wall_begin_pos[0], wall_begin_pos[2])
	var p_1 = Vector2(wall_end_pos[0], wall_end_pos[2])
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
# Charges for 4 seconds and on recasting throws a bullet, up to a maximum of 10

remotesync func ultimate_skill(position):
	.ultimate_skill(position)
	
	if cooldownUltimate.check():
		# Start casting its ultimate
		# The player cannot move, act or interrupt the casting
		status_casting_R = true
#		cast(5)
	
		# Stop casting e (if casting was in progress)
		casting_e = false
		
		# Select the skill (change hud texture)
		if hud != null:
			hud.select_skill(4)
			
		# Show SFX
		ultimate_sfx.show()
		
		ultimate_sfx_progress_texture.scale = Vector3(0,1,0)
		
		# Start the timer which will control how the SFX texture is shown
		sfx_progression_cd.begin()
		
		# Play SFX
		play_sfx(r_cast_sfx)
	
# Override method to execute the action of the R skill after its
# casting has finished
remotesync func end_casting_R():
	# The player was casting its ultimate
	if status_casting_R:
		status_casting_R = false
		
		# Deselect the skill (change hud texture)
		if hud != null:
			hud.deselect_skill(4)
		
		# Stun every enemy player in an area
#		var enemies
#
#		if team == 'team_1':
#			enemies = get_tree().get_nodes_in_group('team_2')
#		else:
#			enemies = get_tree().get_nodes_in_group('team_1')
			
#		for e in enemies:
			# Check if it's close enough
#			var distance = translation.distance_to(e.translation)
			
#			if distance <= R_area_size:
#				e.apply_onCC(R_CC_duration)
				
		cooldownUltimate.begin()
		
		# Hide the SFX
		ultimate_sfx_progress_texture.get_surface_material(0).set_emission_energy(0)
		ultimate_sfx.hide()
		
		# Play SFX
		play_sfx(r_stun_sfx)
