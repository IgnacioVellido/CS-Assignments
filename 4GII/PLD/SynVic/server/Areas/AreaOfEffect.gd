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

func _ready():
	refresh_timer = Timer.new()
	add_child(refresh_timer)
	
	refresh_timer.connect("timeout", self, "refresh_status")
	refresh_timer.start(refresh_timer_period)
	
	if duration != -1:
		duration_timer = Timer.new()
		add_child(duration_timer)
		
		duration_timer.connect("timeout", self, "disappear")
		duration_timer.start(duration)

#===============================================================================

remote func disappear():
	queue_free()
	rpc("disappear")

#===============================================================================

# Refresh the status of all the objects inside the area
func refresh_status():
	var bodies = get_overlapping_bodies()
	
	for b in bodies:
		refresh_status_of_effect(b)

# Apply the effect (called when the debuff is applied to an object the first time)
func apply_status_of_effect(body):
	if not body.is_in_group("obstacle"):
		match status_of_effect:
			"slowness":
				body.apply_slowness(status_intensity, status_duration)
			"vulnerability":
				body.apply_vulnerability(status_intensity, status_duration)
			"tickdmg":
				body.apply_tickdmg(status_intensity, status_duration, status_period)
			
# Refresh the effect (called when the debuff is applied to the same object
# a second time)
func refresh_status_of_effect(body):
	if not body.is_in_group("obstacle"):
		match status_of_effect:
			"slowness":
				body.refresh_slowness()
			"vulnerability":
				body.refresh_vulnerability()
			"tickdmg":
				body.refresh_tickdmg()


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

