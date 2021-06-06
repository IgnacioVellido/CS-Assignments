extends Area

class_name AreaOfEffect

var duration:int # Duration of the zone (after which it disappears)
var duration_timer
var refresh_timer # Every time it actives, the debuff is applied again to the objects in the area
var refresh_timer_period=1

var status_of_effect:String # "slowness", "vulnerability" or "tickdmg"
var status_intensity
var status_duration
var status_period # Only used if status_of_effect == "tickdmg"

#===============================================================================

puppet func disappear():
	queue_free()

#===============================================================================

# Functions to set the collision layers and masks
# They receive as argument a list of integers, referring to the layers/masks
# to set. The others are not set.
# Layers (input of these functions) start at 1, whereas bits start at 0.

func set_collision_layer_from_list(layers):
	var arg : int = 0
	
	for layer in layers:
		arg += pow(2, layer-1)
		
	self.set_collision_layer(arg)
	
func set_collision_mask_from_list(layers):
	var arg : int = 0
	
	for layer in layers:
		arg += pow(2, layer-1)
		
	self.set_collision_mask(arg)

