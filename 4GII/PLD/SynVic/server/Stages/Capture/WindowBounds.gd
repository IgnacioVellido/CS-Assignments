extends Area2D

export var perc_size = 0.9 # Size of the area2D as a percentage of the window size

onready var shape # Shape of its CollisionShape2D

signal camera_move # Emitted when the mouse exits the area2D

func _ready():
	shape = $CollisionShape2D.get_shape()
	
	# Its size is 80% of the window size and it is centered on the window
	var screen_size = get_viewport().get_visible_rect().size
	shape.set_extents(screen_size*perc_size)
	$CollisionShape2D.set_position(screen_size / 2) # Center the area
	
	# Detect when the user resizes the window
	get_tree().get_root().connect("size_changed", self, "_on_viewport_size_changed")

# The size of the area2D is always equal to the 80% of the window size
func _on_viewport_size_changed():
	var screen_size = get_viewport().get_visible_rect().size
	shape.set_extents(screen_size*perc_size)
	$CollisionShape2D.set_position(screen_size / 2) # Center the area

# If the mouse is outside the area, the player camera is moved
func _process(delta):
	var viewport = get_viewport()
	
	# Check if the mouse is outside the area
	var mouse_pos = viewport.get_mouse_position()
	var area_extents = shape.get_extents() / 2 # Extents correspond to half the width and half the height
	var area_center = $CollisionShape2D.get_position()
	
	if mouse_pos[0] < area_center[0] - area_extents[0] or \
	   mouse_pos[0] > area_center[0] + area_extents[0] or \
	   mouse_pos[1] < area_center[1] - area_extents[1] or \
	   mouse_pos[1] > area_center[1] + area_extents[1]:
		
		# Move the camera in the direction of the mouse
		var move_direction = (mouse_pos - area_center).normalized()
		
		# Emit the signal to the player to move the mouse
		emit_signal("camera_move", move_direction, delta)
