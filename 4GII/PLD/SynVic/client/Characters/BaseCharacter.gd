extends KinematicBody
 
class_name BaseCharacter # Base class all different characters must inherit from 

signal died # Emitted when the player dies and respawn.

onready var mesh = $MeshInstance

# ------------------------------------------------------------------------------
# Generic character stats

# Health
var max_health : int
remote var health : int
var healthRegeneration = 0

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

# Status effects
var status_onCC = false         # Can't act
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
remote var puppet_pos # Position on the server
remote var puppet_rot # Rotation on the server

# Dash
var dash_target_position
var dash_speed
var dash_direction

# HUD
onready var hud

# Mouse Position (raycasted onto the floor). This way, I don't need to
# perform raycasting
var curr_mouse_pos

# SFX player
onready var sound_player = $SoundPlayer
var effects_enabled:bool # If false, sound effects won't be played

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

# Camera
var cam
onready var camera
onready var stage
var camera_mode = "auto" # If "auto", the camera follows the player. If "manual", the player moves it with the mouse.
export var camera_initial_pos = Vector3(0.0,25.0,13.0) # Initial position of the camera (when camera_mode is "auto")

#===============================================================================

# Called before _ready()
func set_team(my_team):
	# Assign group
	add_to_group(my_team)
	team = my_team
	enemy_team = "team_1" if team == "team_2" else "team_2"

func _ready():
	# HUD
	if is_network_master():
		hud = load("res://GUI/GUI.tscn").instance()
		self.add_child(hud)
		
		camera = Camera.new()
		camera.name = "Camera"
		camera.translation = Vector3(0,25,13)
		camera.rotation_degrees = Vector3(-65,0,0)
		self.add_child(camera)
		
		# Associate camera and detect when the mouse exits the viewport (camera control)
		$"../../WindowBounds".connect("camera_move", self, "move_camera")
		stage = get_tree().get_root().get_node("Stage")
	
	# Need to convert 3D coord of the player to place correctly the label
	$Name/TextureRect/NameLabel.text = player_name
	
	# Notify the stage when it dies
#	self.connect("died", get_tree().get_root().get_node("Stage"), "player_died")
	
	# Make the player able to click on every obstacle of the map, moving in their
	# direction
	var obstacles = get_tree().get_nodes_in_group("obstacle")
	for obs in obstacles:
		obs.connect("input_event", self, "_on_Map_input_event")
	
	puppet_pos = spawn_pos
	puppet_rot = rotation
	
	# Make meshInstance material unique (not shared with other instances)
	mesh.set_surface_material(0, mesh.get_surface_material(0).duplicate())
	
	# Sound
	if audio_config.master_volume_enabled and audio_config.effects_volume_enabled:
		effects_enabled = true
		
		# Set the correct volume given by audio_config.gd
		sound_player.set_unit_db(audio_config.get_effects_db())
	
	# Collision layers
	if team == "team_1":
		self.set_collision_layer_bit(0,1)
		self.set_collision_mask_bit(10, 1024)
		self.set_collision_mask_bit(1, 2)
		self.set_collision_mask_bit(2, 4)
		self.set_collision_mask_bit(4, 16)
		$Name/TextureRect/NameLabel.add_color_override("font_color", Color(0,1,0))
	else:
		self.set_collision_layer_bit(1,2)
		self.set_collision_mask_bit(0, 1)
		self.set_collision_mask_bit(2, 4)
		self.set_collision_mask_bit(3, 8)
		$Name/TextureRect/NameLabel.add_color_override("font_color", Color(1,0,0))

# Called after all players are in match
remotesync func connect_enemies():
	var enemies = get_tree().get_nodes_in_group(enemy_team)

	for enemy in enemies:
		enemy.connect("input_event", self, "_on_Enemy_input_event", [enemy])
		
	cam = get_tree().get_root().get_camera()

#===============================================================================

func _process(delta):
	# Set nametag position
	var pos = translation
	pos.y = 0
	var screenPos = cam.unproject_position(pos)
	screenPos.y -= 85
	screenPos.x -= 25
	$Name.set_position(screenPos)
	
	# Intentando que haya un offset según lo alejado que esté del centro de la
	# cámara -> No funciona
#	var pos = translation
#	var screenPos = cam.unproject_position(pos)
#	var viewSize = get_viewport().size
#	var viewCenter = Vector2(viewSize.x / 2, viewSize.y / 2)
#	screenPos.x -= 0.5 * (screenPos.x - viewCenter.x)
#	screenPos.y -= 0.5 * (screenPos.y - viewCenter.y)
#	$NameLabel.set_position(screenPos)
	
	# Only updates if we are the player
	if is_network_master():
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
		
		# HUD
		if is_network_master():
			update_health()
			update_HUD_cooldowns()

# Called after cooldownCasting is ready
func end_casting():
	print("End casting")
	
	cooldownCasting.free()
	status_casting = false
	
	# The player can interact again
	status_immobilized = false
	listenToBasic = true
	listenToSkill1 = true
	listenToSkill2 = true
	listenToSkill3 = true
	listenToUltimate = true

#===============================================================================
 
func _physics_process(delta):
	# sync to last known position and velocity
	translation = puppet_pos
	$MeshInstance.rotation = puppet_rot

#===============================================================================
# Inputs
# These functions are only used if "is_network_master()" is True
#===============================================================================

remote func input_click(click_position):
	pass

# Used for Keyboard Inputs
func _input(ev):	
	if is_network_master():
		# Switch camera between "auto" and "manual"
		if Input.is_action_just_pressed("switch_camera_mode"):
			switch_camera_mode()
		
		# Cast a skill
		if not status_onCC:	
			if listenToSkill1 and Input.is_action_pressed("ui_skill1"):
				rpc("skill_1", curr_mouse_pos)
			if listenToSkill2 and Input.is_action_pressed("ui_skill2"):
				rpc("skill_2", curr_mouse_pos)
			if listenToSkill3 and  Input.is_action_pressed("ui_skill3"):
				rpc("skill_3", curr_mouse_pos)
			if listenToUltimate and Input.is_action_pressed("ui_skill_ultimate"):
				rpc("ultimate_skill", curr_mouse_pos)

# Called when the player moves the mouse over the floor or any obstacle
func _on_Map_input_event(camera, event, click_position, click_normal, shape_idx):
	if is_network_master():
		# Store the current position of the mouse
		curr_mouse_pos = click_position
		
		if Input.is_action_pressed("ui_move_action"): # ~See Proyect -> Input Map
			rpc_id(1, "input_click", click_position)

# Called when the player moves the mouse over an enemy (or dummy)
func _on_Enemy_input_event(camera, event, click_position, click_normal, shape_idx, enemy):	
	if is_network_master():
		if not status_onCC:
			if listenToSkill1 and Input.is_action_pressed("ui_skill1"):
				rpc("skill_1", click_position)
			if listenToSkill2 and Input.is_action_pressed("ui_skill2"):
				rpc("skill_2", click_position)
			if listenToSkill3 and  Input.is_action_pressed("ui_skill3"):
				rpc("skill_3", click_position)
			if listenToUltimate and Input.is_action_pressed("ui_skill_ultimate"):
				rpc("ultimate_skill", click_position)
			
			# If the player has clicked onto the enemy, it chases it and attacks it when it gets in range
			if listenToBasic and Input.is_action_pressed("ui_basic_skill"):
				print("Setting enemy: ", enemy.name)
				rset_id(1, "movement_state", 2)
				rset_id(1, "movement_target_name", enemy.name)

#===============================================================================
# Dashing
# Right now not necessary because players can pass through units
#===============================================================================

func endDash():
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
remotesync func basic_skill(enemy):
	pass

remotesync func skill_1(position):
	pass
	
remotesync func skill_2(position):
	pass
	
remotesync func skill_3(position):
	pass
	
remotesync func ultimate_skill(position):
	pass

#===============================================================================
# HUD
#===============================================================================

func update_health():
	hud.set_max_health(max_health)
	hud.update_health(health)

func update_HUD_cooldowns():
	# *10 = 1 decimal -> better visual in hud
	hud.set_max_cooldown(1, cooldownSkill1.max_time*10) 
	hud.update_cooldown(1, cooldownSkill1.time*10)
	
	hud.set_max_cooldown(2, cooldownSkill2.max_time*10)
	hud.update_cooldown(2, cooldownSkill2.time*10)
	
	hud.set_max_cooldown(3, cooldownSkill3.max_time*10)
	hud.update_cooldown(3, cooldownSkill3.time*10)
	
	hud.set_max_cooldown(4, cooldownUltimate.max_time*10)
	hud.update_cooldown(4, cooldownUltimate.time*10)
	
#===============================================================================
# Damage
#===============================================================================

# The player receives damage
func on_hit(damage):
	health -= damage
	
	print("Health:", health)
	
	if health <= 0:
		respawn()


# The player respawns
func respawn():
	print("Player respawned")
	health = max_health
	
	translation = spawn_pos
	
	# Notify the stage a player has died
	emit_signal("died", team)

#===============================================================================
# Camera Control
#===============================================================================	

# Changes from "auto" to "manual" and viceversa
func switch_camera_mode():
	if camera_mode == "manual":
		camera_mode = "auto"
		
		# Now the camera is manual, so its parent is the player
		call_deferred("reparent", camera, self)
		
		# Change sistem of coordinates and center camera onto the player
		var new_camera_pos = camera_initial_pos
		camera.set_translation(new_camera_pos)
	else:
		camera_mode = "manual"
		
		# Now the camera is fixed, so its parent is the node "Stage"
		call_deferred("reparent", camera, stage)
		
		# Change system of coordinates
		var new_camera_pos = camera.translation + self.translation 
		camera.set_translation(camera_initial_pos)
	
func reparent(node, new_parent):
	node.get_parent().get_parent().remove_child(node)
	new_parent.add_child(node)
	
# Move the camera along move_direction if camera_mode is "manual"
func move_camera(move_direction, delta):
	if camera_mode == "manual":
		var camera_sensitivity = 25 # The higher, the quicker the camera moves
		
		var move_vector = Vector3(move_direction[0],0,move_direction[1])*camera_sensitivity*delta # Convert from Vector2 to Vector3
		var new_camera_pos = camera.translation + move_vector 
		camera.set_translation(new_camera_pos)

#===============================================================================
# Sound
#===============================================================================	

# Play a sound effect ONLY IF effects_enabled is true!
func play_sfx(sfx):
	if effects_enabled:
		sound_player.stream = sfx
		sound_player.play()
	
# Stop playing the current sfx	
func stop_sfx():
	sound_player.stop()
