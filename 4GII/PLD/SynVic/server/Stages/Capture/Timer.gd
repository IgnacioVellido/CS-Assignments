extends Timer

onready var time_board = $Timeboard

var current_time:int # Variable to store the current time left and only update the time_board when needed

#===============================================================================
#===============================================================================

func _ready():
	# Set the time_board to the initial time
	show_time_left(wait_time)
	
# Start the timer (time_sec = -1 is the default option for a timer of 5 minutes)
func start(time_sec=-1):
	.start(time_sec)
	current_time = wait_time

func _process(delta):
	if int(time_left) != current_time:
		current_time = int(time_left)		
		show_time_left(current_time)
	
# Show the time left on the time_board
func show_time_left(seconds_left):
	var minsec = seconds_to_minsec(seconds_left) # Convert from seconds to minutes and seconds
	
	# Output format
	if minsec[1] == 0:
		time_board.text = String(minsec[0]) + " : 00"
	else:
		time_board.text = String(minsec[0]) + " : " + String(minsec[1])
	
# Functions to convert from seconds to minute, seconds and viceversa
func seconds_to_minsec(seconds):
	var _min = int(seconds) / 60 # Integer division
	var _sec = int(seconds) % 60
	
	return [_min, _sec]
	
func minsec_to_seconds(minutes, seconds):
	return int(minutes*60 + seconds)


