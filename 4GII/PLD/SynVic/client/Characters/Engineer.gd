extends BaseCharacter

class_name Engineer

#===============================================================================

# Speeds
var basicBulletSpeed = 15
var skill1BulletSpeed = 20
var skill2BulletSpeed = 20
var skill3BulletSpeed = 10
var ultimateBulletSpeed = 50

remote var num_bouncing_projectiles = 0 # Current number of bouncing projectiles
var max_bouncing_projectiles = 3 # Maximum number of bouncing projectiles that can exist at the same time
var next_bouncing_proj_name = 0

# Additional skill cooldowns
var cooldownLoadUltimate # Channeling
var cooldownShootUltimate # Cooldown between bullets

var ultimateBullets = 0
var maxUltimateBullets = 10

var status_onUltimate = false

# Sound Effects (SFX)
var basic_cast_sfx = preload("res://Audio/SFX/Engineer/basic_cast.wav")
var q_cast_sfx = preload("res://Audio/SFX/Engineer/q_cast.wav")
var w_cast_sfx = preload("res://Audio/SFX/Engineer/w_cast.wav")
var e_cast_sfx = preload("res://Audio/SFX/Engineer/e_cast.wav")
var r_cast_sfx = preload("res://Audio/SFX/Engineer/r_cast.wav")
var r_shoot_sfx = preload("res://Audio/SFX/Engineer/r_shoot.wav")

#===============================================================================

func _ready():
	# Initializing stats - Must be changed also in the server
	max_health = 200
	health = 200
	healthRegeneration = 0
	basicRange = 20
	
	# Cooldowns
	cooldownBasic = Cooldown.new(1)
	cooldownSkill1 = Cooldown.new(3)
	cooldownSkill2 = Cooldown.new(10)
	cooldownSkill3 = Cooldown.new(1)
	cooldownUltimate = Cooldown.new(30)
	
	# Extra Skill Cooldowns
	cooldownLoadUltimate = Cooldown.new(4)
	cooldownShootUltimate = Cooldown.new(0.5)
	
	# Show how many grenades the player can shoot at the same time with
	# its E skill
	if hud != null:
		hud.set_label_casting(3, max_bouncing_projectiles)

#===============================================================================

func _process(delta):
	._process(delta)
	
	if status_onUltimate:
		cooldownLoadUltimate.tick(delta)
		
		if cooldownLoadUltimate.check():
			# Show the remaining bullets on the hud
			show_ultimate_bullets()
		
		cooldownShootUltimate.tick(delta)
		
	if is_network_master():
		hud.set_label_casting(3, max_bouncing_projectiles-num_bouncing_projectiles)

func _on_Map_input_event(camera, event, click_position, click_normal, shape_idx):
	if is_network_master():
		._on_Map_input_event(camera, event, click_position, click_normal, shape_idx)
		
		# If the ultimate is active, it is reset
		if Input.is_action_pressed("ui_move_action"):
			if status_onUltimate:
				rpc("reset_ultimate")

#===============================================================================
# - Skills -
#===============================================================================
# Ranged attack

func basic_skill(enemy):
	.basic_skill(enemy)
	
	# Play SFX
	if cooldownBasic.check():
		play_sfx(basic_cast_sfx)

#-------------------------------------------------------------------------------
# Throws a bullet that damage enemies

remotesync func skill_1(position):	
	.skill_1(position)
	
	# Play SFX
	if cooldownSkill1.check():
		play_sfx(q_cast_sfx)
	
	cooldownSkill1.is_ready()

#-------------------------------------------------------------------------------
# Throws a hook that collides with the terrain, making her dash to it

remotesync func skill_2(position):
	.skill_2(position)
	
	# Play SFX
	if cooldownSkill2.is_ready():
		cooldownSkill2.stop()
		play_sfx(w_cast_sfx)

#-------------------------------------------------------------------------------
# Throws a grenade that bounces and explode on enemy impact or after a fixed
# number of bounces

remotesync func skill_3(position):
	.skill_3(position) # We will probably make some code in the super class
	
	if cooldownSkill3.is_ready() and num_bouncing_projectiles < max_bouncing_projectiles:
		# Play SFX
		play_sfx(e_cast_sfx)
		
		num_bouncing_projectiles += 1

#-------------------------------------------------------------------------------
# Charges for 4 seconds and on recasting throws a bullet, up a maximum of 10

remotesync func ultimate_skill(position):
	.ultimate_skill(position)
	
	if not status_onUltimate:
		if cooldownUltimate.check():
			print("4 seconds channeling")
			status_onUltimate = true
			listenToBasic = false
			listenToSkill1 = false
			listenToSkill2 = false
			listenToSkill3 = false

			# Select the skill (change hud texture)
			if hud != null:
				hud.select_skill(4)

			# Play casting SFX
			play_sfx(r_cast_sfx)

			# Begin channeling
			cooldownLoadUltimate.begin()
	else:
		
		# Throw a bullet
		if cooldownLoadUltimate.check() and cooldownShootUltimate.is_ready():
			# Play shoot SFX
			play_sfx(r_shoot_sfx)
			
			ultimateBullets += 1
			
		if ultimateBullets == maxUltimateBullets:
			reset_ultimate()

# Called when the ultimate is reset or when the maximum number of bullets have been shot
remotesync func reset_ultimate():
	ultimateBullets = 0
	
	# Put status
	status_onUltimate = false
	listenToBasic = true
	listenToSkill1 = true
	listenToSkill2 = true
	listenToSkill3 = true
	
	# Deselect the skill (change hud texture) and hide the casting_label
	if hud != null:
		hud.deselect_skill(4)
		hud.set_label_casting(4, -1)
		
	# Reset cooldown
	cooldownUltimate.begin()

func show_ultimate_bullets():
	# Show the remaining bullets
	if hud != null:
		hud.set_label_casting(4, maxUltimateBullets-ultimateBullets)

#===============================================================================
# Signals
#===============================================================================

# Moves to the position indicated in the signal
# It should recieve a speed parameter to make it generic
func _on_HookProjectile_moveTo(trans):
	pass

remotesync func resetSkill2Cooldown():
	cooldownSkill2.resume()
