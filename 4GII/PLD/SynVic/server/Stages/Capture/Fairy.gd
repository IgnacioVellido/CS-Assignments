extends KinematicBody

# Root node of the scene, which increases the score of the teams
onready var stage = $"../../../../Stage"
onready var score_timer = $AddPointsTimer

# Number of players that are currently inside the area
var num_players_team_1_inside : int = 0
var num_players_team_2_inside : int = 0

# Variables that decide how points are added
export var score_timer_rate = 1 # The period points are added
export var points_per_player : int = 1 # How many points are awarded for every player inside the area in each period

# -Variables for movement-

onready var path = $"../../../FairyPath" # FairyPath node
onready var path_follow = $"../../PathFollow" # PathFollow node

# The position of the fairy after it has finished walking the current path
var current_pos : int = 0 # 0:center, 1-upper_left, 2-upper_right, 3-lower_right, 4-lower_left

export var speed = 1.0 # Speed at which the fairy moves

# The fairy spends a time in [mean-variance , mean+variance] before choosing a new path
export var idle_time_mean = 20.0
export var idle_time_variance = 5.0 
var idle_time_finished = true # If false, a new path has been chosen but the idle_time has not finished
onready var idle_timer = $IdleTimer

var spawn_pos = Vector3(0,1,0)
puppet var puppet_pos

#===============================================================================
#===============================================================================

# Start the timer
func _ready():
	score_timer.start(score_timer_rate)
	
	# Initialize the path
	choose_next_path()
	
	puppet_pos = spawn_pos

#===============================================================================

func _physics_process(delta):
	# Follow the current path
	if path_follow.unit_offset < 1.00:
		# Follow the path
		path_follow.offset += delta*speed
	# If the path is finished, choose a new one after some time has passed
	else:
		if idle_time_finished:
			idle_time_finished = false
			
			# Start the idle timer
			randomize()
			var idle_time = randf()*2*idle_time_variance + idle_time_mean-idle_time_variance
			idle_timer.start(idle_time)
			
	rset_unreliable("puppet_pos", get_parent().translation)

# Functions to check how many players are inside the area
func _on_FairyArea_body_entered(body):	
	if body.is_in_group("team_1"):
		num_players_team_1_inside += 1
	elif body.is_in_group("team_2"):
		num_players_team_2_inside += 1

func _on_FairyArea_body_exited(body):
	if body.is_in_group("team_1"):
		num_players_team_1_inside -= 1
	elif body.is_in_group("team_2"):
		num_players_team_2_inside -= 1

# Add the points
func _on_AddPointsTimer_timeout():
	var num_points_team_1 = num_players_team_1_inside*points_per_player
	var num_points_team_2 = num_players_team_2_inside*points_per_player
	
	stage.add_points("team_1", num_points_team_1)
	stage.add_points("team_2", num_points_team_2)

#===============================================================================
# Functions for the movement
#===============================================================================

# Choose next path to follow randomly
func choose_next_path():
	randomize()
	var r = (randi() % 4) + 1
	var end_pos : int
	
	# Choose the end position of next path depending on the current position of the fairy
	match current_pos:
		0: # Center
			end_pos = r	
		1: # Upper Left
			match r:
				1:
					end_pos = 2
				2:
					end_pos = 4
				3, 4:
					end_pos = 0
		2: # Upper Right
			match r:
				1:
					end_pos = 1
				2:
					end_pos = 3
				3, 4:
					end_pos = 0
		3: # Lower Right
			match r:
				1:
					end_pos = 2
				2:
					end_pos = 4
				3, 4:
					end_pos = 0
		4: # Lower Left
			match r:
				1:
					end_pos = 1
				2:
					end_pos = 3
				3, 4:
					end_pos = 0
		
	# Load the path and initialize it
	var current_path = "res://FairyPaths/path_%d-%d.tres" % [current_pos, end_pos]
	path.set_curve(load(current_path))
	path_follow.offset = 0
	
	# Store the end position of the current path
	current_pos = end_pos
		
# The fairy has finished its idle time so it chooses a new path and starts to move again
func _on_IdleTimer_timeout():
	choose_next_path()
	idle_time_finished = true
