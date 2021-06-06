extends Node

var projectile = preload("res://Projectiles/BaseProjectile.tscn")
var homing_projectile = preload("res://Projectiles/HomingProjectile.tscn")
var hook_projectile = preload("res://Projectiles/HookProjectile.tscn")
var bouncing_projectile = preload("res://Projectiles/BouncingProjectile.tscn")
var pierce_projectile = preload("res://Projectiles/PierceProjectile.tscn")

var stage_node

func set_stage_node():
	stage_node = get_tree().get_root().get_node("Stage")

#===============================================================================
# Spawning projectiles remotesync functions
#===============================================================================

var homingProjCounter = 0

remotesync func spawn_homingProjectile(name, transform, team, p_speed, enemy):
	var p = homing_projectile.instance()
	p.name = "HomProj_" + name # Important
	
	# If already projectile with the same name, change it
	if stage_node.has_node(p.name):
		p.name += "_" + String(homingProjCounter)
		homingProjCounter += 1
	
	p.transform = transform
	p.speed = p_speed
	p.target = enemy # Pass enemy as an argument, so that it can track its position
	p.team = team
	
	# Networking
	p.set_network_master(1)
	
	# Set collision layer and mask
	# It can only collide with the enemy players.
	if team == 'team_1':
		p.set_collision_layer_from_list([4])
		p.set_collision_mask_from_list([2]) 
	else:
		p.set_collision_layer_from_list([5])
		p.set_collision_mask_from_list([1]) 
	
	stage_node.add_child(p)

#-------------------------------------------------------------------------------

var baseProjCounter = 0

remotesync func spawn_baseProjectile(name, transform, team,
											translation, p_speed, position):
	var direction = (position - translation).normalized()
	direction[1] = 0

	# Create a new projectile
	var p = projectile.instance()
	p.name = "BaseProj_" +  name # Important
	
	# If already projectile with the same name, change it
	if stage_node.has_node(p.name):
		p.name += "_" + String(baseProjCounter)
		baseProjCounter += 1
	
	p.transform = transform
	p.direction = direction
	p.speed = p_speed
	p.team = team
	
	p.set_network_master(1)
	
	# Set collision layer and mask
	# It can collide with the other obstacles and the enemy players.
	if team == 'team_1':
		p.set_collision_layer_from_list([4])
		p.set_collision_mask_from_list([2, 3]) 
	else:
		p.set_collision_layer_from_list([5])
		p.set_collision_mask_from_list([1, 3]) 
	
	stage_node.add_child(p)

#-------------------------------------------------------------------------------

remotesync func spawn_hookProjectile(name, transform, team, player,
											translation, p_speed, position):
	var direction = (position - translation).normalized()
	direction[1] = 0

	# Create a new projectile
	var p = hook_projectile.instance()
	p.name = "HookProj_" + name # Important
	# Signal with the hook effect: Move the character to the position
	p.connect('moveTo', player, '_on_HookProjectile_moveTo')
	p.transform = transform
	p.direction = direction
	p.speed = p_speed
	p.team = team
	
	p.set_network_master(1)
	
	# Set collision layer and mask
	# It can only collide with the terrain, but not the enemies.
	# Should it collide with the player's own projectiles ?
	if team == 'team_1':
		p.set_collision_layer_from_list([6])
		p.set_collision_mask_from_list([3]) 
	else:
		p.set_collision_layer_from_list([7])
		p.set_collision_mask_from_list([3]) 
	
	stage_node.add_child(p)

#-------------------------------------------------------------------------------

remotesync func spawn_bouncingProjectile(name, transform, team, player,
											translation, p_speed, position):
	var direction = (position - translation).normalized()
	direction[1] = 0

	# Create a new projectile
	var p = bouncing_projectile.instance()
	p.name = "BounProj_" + name
	p.transform = transform
	p.direction = direction
	p.speed = p_speed
	p.team = team
	
	p.set_network_master(1)
	
	# Set collision layer and mask
	# It can collide with the other obstacles and the enemy players.
	if team == 'team_1':
		p.set_collision_layer_from_list([4])
		p.set_collision_mask_from_list([2, 3]) 
	else:
		p.set_collision_layer_from_list([5])
		p.set_collision_mask_from_list([1, 3]) 
	
	stage_node.add_child(p)

#-------------------------------------------------------------------------------

remotesync func spawn_pierceProjectile(name, transform, team,
											translation, p_speed, position):
	var direction = (position - translation).normalized()
	direction[1] = 0
	
	# Create a new projectile
	var p = pierce_projectile.instance()
	p.name = "PierProj_" + name
	p.transform = transform
	p.direction = direction
	p.speed = p_speed
	p.team = team
	
	p.set_network_master(1)
	
	# Set collision layer and mask
	# It can only collide with the enemy players.
	# It cannot collide with the enemy projectiles ?
	if team == 'team_1':
		p.set_collision_layer_from_list([4])
		p.set_collision_mask_from_list([2]) 
	else:
		p.set_collision_layer_from_list([5])
		p.set_collision_mask_from_list([1]) 
	
	stage_node.add_child(p)
