extends KinematicBody

var spawn_pos = Vector3(0,1,0)
remote var puppet_pos

# Start the timer
func _ready():
	puppet_pos = spawn_pos

func _physics_process(delta):
	# sync to last known position and velocity
	get_parent().translation = puppet_pos
