extends Node

var area = preload("res://Areas/AreaOfEffect.tscn")

var stage_node

var area_num: int = 0

func set_stage_node():
	stage_node = get_tree().get_root().get_node("Stage")

#===============================================================================
# Spawning projectiles functions
#===============================================================================

remotesync func spawn_Area(name, transform, team, area_duration, area_size, chosen_status):
	var new_area = area.instance()
	
	new_area.name = "Area_" + name + "_" + String(area_num)# Important
	new_area.translation = transform
	new_area.translation[1] = 1
	new_area.scale = Vector3(area_size,1,area_size)
	new_area.duration = area_duration
	
	area_num += 1
	
#	# Choose a random debuff in {vulnerability, tickdmg, slowness}
#	var possible_status = ["slowness", "vulnerability", "tickdmg"]
#	randomize()
#	new_area.status_of_effect = possible_status[randi() % 3]
	new_area.status_of_effect = chosen_status
	
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
