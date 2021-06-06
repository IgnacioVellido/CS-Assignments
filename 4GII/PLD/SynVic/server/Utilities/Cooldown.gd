extends Timer

var time = 0.0
var max_time = 0.0
var stopped = false

#===============================================================================

# By default start without cooldown
func _init(max_time):
	self.max_time = max_time
	self.time = 0

#===============================================================================

func tick(delta):
	if not stopped:
		time = max(time - delta, 0)

#===============================================================================

# Checks timer and resets
func is_ready():
	if time > 0:
		return false
	time = max_time
	return true

#===============================================================================

# Sets the cooldown to max_time
func begin():
	time = max_time

#===============================================================================

# Check if cooldown is completed
func check():
	return time == 0

#===============================================================================

func set_max_time(t):
	max_time = t

#===============================================================================

func stop():
	stopped = true

func resume():
	stopped = false
