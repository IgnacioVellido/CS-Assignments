extends Node

var area = preload("res://Areas/AreaOfEffect.tscn")

# Texture for each debuff
var fire_texture = preload("res://Models/Mage/Skills/fire.jpg")
var ice_texture = preload("res://Models/Mage/Skills/ice.png")
var poison_texture = preload("res://Models/Mage/Skills/poison.jpg")

var area_num: int = 0

var stage_node

func set_stage_node():
	stage_node = get_tree().get_root().get_node("Stage")

#===============================================================================
# Spawning projectiles remotesync functions
#===============================================================================

remotesync func spawn_Area(name, transform, team, area_duration, area_size, chosen_status):
	var new_area = area.instance()
	
	new_area.name = "Area_" + name + "_" +  String(area_num) # Important
	new_area.translation = transform
	new_area.translation[1] = 1
	new_area.scale = Vector3(area_size,1,area_size)
	new_area.duration = area_duration
	
	area_num += 1
	
	# Networking
	new_area.set_network_master(1)
	
	new_area.status_of_effect = chosen_status
	
	# Associate texture to the chosen debuff
	
	# Create material
	var material = SpatialMaterial.new()
	
	match chosen_status:
		"slowness":
			material.set_texture(0, ice_texture)
		"vulnerability":
			material.set_texture(0, poison_texture)
		"tickdmg":
			material.set_texture(0, fire_texture)
	
	new_area.get_node("MeshInstance").set_surface_material(0, material)
	
	new_area.status_intensity = 10
	new_area.status_duration = 4
	new_area.status_period = 1
	
	# Set collision layer and mask
	# It can only collide with the enemy players.
	if team == 'team_1':
		new_area.set_collision_layer_from_list([4])
		new_area.set_collision_mask_from_list([2, 4]) 
	else:
		new_area.set_collision_layer_from_list([5])
		new_area.set_collision_mask_from_list([1, 5]) 
	
	stage_node.add_child(new_area)

#-------------------------------------------------------------------------------
