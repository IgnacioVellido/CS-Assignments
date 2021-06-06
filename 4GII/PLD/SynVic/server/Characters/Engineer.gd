extends BaseCharacter

class_name Engineer

#===============================================================================

# Speeds
var basicBulletSpeed = 15
var skill1BulletSpeed = 20
var skill2BulletSpeed = 20
var skill3BulletSpeed = 10
var ultimateBulletSpeed = 50

puppet var num_bouncing_projectiles = 0 # Current number of bouncing projectiles
var max_bouncing_projectiles = 3 # Maximum number of bouncing projectiles that can exist at the same time
var next_bouncing_proj_name = 0
var next_piercing_proj_name = 0

# Additional skill cooldowns
var cooldownLoadUltimate # Channeling
var cooldownShootUltimate # Cooldown between bullets

var ultimateBullets = 0
var maxUltimateBullets = 10

var status_onUltimate = false

#===============================================================================

func _ready():
	# Initializing stats
	max_health = 200
	health = 200
	speed = 10
	healthRegeneration = 0
	basicRange = 20
	
	# Cooldowns
	cooldownBasic = Cooldown.new(1)
	cooldownSkill1 = Cooldown.new(3)
	cooldownSkill2 = Cooldown.new(10)
	cooldownSkill3 = Cooldown.new(1)
	cooldownUltimate = Cooldown.new(30)
	cooldownCasting = Cooldown.new(1)
	
	# Extra Skill Cooldowns
	cooldownLoadUltimate = Cooldown.new(4)	
	cooldownShootUltimate = Cooldown.new(0.5)

#===============================================================================

func _process(delta):
	._process(delta)
	
	if status_onUltimate:
		cooldownLoadUltimate.tick(delta)
		cooldownShootUltimate.tick(delta)

#===============================================================================
# - Skills -
#===============================================================================

remotesync func basic_skill(enemy):
	.basic_skill(enemy)
	
	# We know the character is in range	
	if cooldownBasic.is_ready():
		projectileSpawner.rpc("spawn_homingProjectile", self.name, 
				global_transform, team, basicBulletSpeed, enemy)

#-------------------------------------------------------------------------------
# Throws a bullet that damage enemies

remotesync func skill_1(position):
	.skill_1(position) # We will probably make some code in the super class
	
	# We should't trust the clients (they should recive the cooldown value each frame)
	if cooldownSkill1.is_ready():
		projectileSpawner.rpc("spawn_baseProjectile", self.name, 
				global_transform, team, translation, skill1BulletSpeed, 
				position)
		
		# Immobilize the player while the skill is being casted
		cast(1)

#-------------------------------------------------------------------------------
# Throws a hook that collides with the terrain, making her dash to it

remotesync func skill_2(position):
	.skill_2(position) # We will probably make some code in the super class

	# We mustn't trust the clients
	if cooldownSkill2.is_ready():
		cooldownSkill2.stop()
		projectileSpawner.rpc("spawn_hookProjectile", self.name, 
				global_transform, team, self, translation, skill2BulletSpeed, 
				position)
		
		# The player is immobilized until the projectil hits something or for ten seconds
		cast(10)

#-------------------------------------------------------------------------------
# Throws a grenade that bounces and explode on enemy impact or after a fixed
# number of bounces

remotesync func skill_3(position):
	.skill_3(position) # We will probably make some code in the super class
	
	if cooldownSkill3.is_ready() and num_bouncing_projectiles < max_bouncing_projectiles:
		# To don't repeat names
		next_bouncing_proj_name += 1
		next_bouncing_proj_name %= max_bouncing_projectiles*2
		var p_name = self.name + String(next_bouncing_proj_name)
		
		projectileSpawner.rpc("spawn_bouncingProjectile", p_name, 
				global_transform, team, self, translation, skill3BulletSpeed, position)
		
		num_bouncing_projectiles += 1
		
		# Immobilize the player while the skill is being casted
		cast(0.5)

# Update the counter "num_bouncing_projectiles" after a bouncing projectile has exploded
func _on_bouncing_projectile_explosion():
	rset("num_bouncing_projectiles", num_bouncing_projectiles-1)

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
			
			stop() # Delete current movement path
			
			# Begin channeling
			cooldownLoadUltimate.begin()
	else:
		# Throw a bullet
		if cooldownLoadUltimate.check() and cooldownShootUltimate.is_ready():
			ultimateBullets += 1
			
			next_piercing_proj_name += 1
			next_piercing_proj_name %= maxUltimateBullets*2
			var p_name = self.name + String(next_piercing_proj_name)
			
			projectileSpawner.rpc("spawn_pierceProjectile", p_name, 
					global_transform, team, translation, ultimateBulletSpeed, 
					position)
			
		if ultimateBullets == maxUltimateBullets:
			reset_ultimate()

# Called when the ultimate is reset or when the maximum number of bullets have been shot
puppet func reset_ultimate():
	ultimateBullets = 0
	
	# Put status
	status_onUltimate = false
	listenToBasic = true
	listenToSkill1 = true
	listenToSkill2 = true
	listenToSkill3 = true
	
	# Reset cooldown
	cooldownUltimate.begin()

#===============================================================================
# Signals
#===============================================================================

# Moves to the position indicated in the signal
# It should recieve a speed parameter to make it generic
func _on_HookProjectile_moveTo(trans):
	dash_direction = (trans.origin - transform.origin).normalized()
	dash_speed = 50
	status_dashing = true
	dash_target_position = trans.origin
	$CollisionShape.disabled = true
	
	# Start cooldown W
	rpc("resetSkill2Cooldown")

remotesync func resetSkill2Cooldown():
	cooldownSkill2.resume()
