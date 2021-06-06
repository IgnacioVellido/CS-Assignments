extends Spatial

# Score
var team_1_score : int = 0
var team_2_score : int = 0

# GUI
onready var scoreboard = $Scoreboard

# Main Menu
var main_menu_scene = "res://Menus/MainMenu.tscn"
const Engineer = preload('res://Characters/Engineer.tscn')
const Mage = preload('res://Characters/Mage.tscn')

# Sound
onready var music_player = $AudioStreamPlayer

#===============================================================================
#===============================================================================

func _ready():
	# Toggle Fullscreen
	OS.window_fullscreen = true
	
	# Initialize the scoreboard
	update_scoreboard()
	
	# Start the timer with 5 minutes
	$Timer.start()
	
	# These scripts need the node of the stage
	projectileSpawner.set_stage_node()
	areaSpawner.set_stage_node()
	
	# Start playing the music
	if audio_config.master_volume_enabled and audio_config.music_volume_enabled:
		# Set the correct volume given by audio_config.gd
		music_player.set_volume_db(audio_config.get_music_db())
		
		music_player.play()

#===============================================================================

# TODO: Generic class stage with these functions, in this class only game rules
# Add other players
puppet func spawn_player(team, id, player_name, player_character):
	# Set position based on the team
	var spawn_position
	if team == "team_1":
		spawn_position = Vector3(-54,0.8,0)
	else:
		spawn_position = Vector3(+54,0.8,0)
	
	var player
	if player_character == "Engineer":
		player = Engineer.instance()
	else:
		player = Mage.instance()
	
	player.translation = spawn_position
	player.spawn_pos = spawn_position
	player.name = "P_" + String(id) # Important
	player.set_network_master(id) # Important
	player.set_team(team)
	player.player_name = player_name
	
	$Players.add_child(player)

#===============================================================================

# When the match ends, the game transitions to a scene
# showing if the player has won or lost the game
puppet func finish_game(winner):
	var end_game_scene

	# The scene depends on the victory or loss of the player
	if winner:
		end_game_scene = "res://Menus/GameEndWinner.tscn"
	else:
		end_game_scene = "res://Menus/GameEndLoser.tscn"
	
	rpc_id(1, "close_stage")
	
	print("Closing Stage scene")
	get_tree().change_scene(end_game_scene)
	self.hide()
	self.queue_free()
	
remotesync func close_stage():
	pass

#===============================================================================
# Rules
#===============================================================================

# Adds points to the corresponding team (a player of that team is inside the area)
puppet func add_points(team, points):
	if team == "team_1":
		team_1_score += points
	else:
		team_2_score += points
	
	# Update the scoreboard
	update_scoreboard()

# Updates the scoreboard with the points of both teams
func update_scoreboard():
	var score_text = String(team_1_score) + " - " + String(team_2_score)
	scoreboard.text = score_text
