extends Spatial

# Score
export var num_lifes : int = 5 # Number of times a player must die in order to finish the game
var team_1_lifes : int # Remaining lifes of each time
var team_2_lifes : int

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
	
	team_1_lifes = num_lifes
	team_2_lifes = num_lifes
	
	# Initialize the scoreboard
	scoreboard.text = String(team_1_lifes) + " - " + String(team_2_lifes)
	
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
puppet func spawn_player(team, id, player_name, player_character):
	print("Player ", id, " registered as ", player_name, " with ", player_character)
	# Set position based on the team
	var spawn_position
	if team == "team_1":
		spawn_position = Vector3(-28,0.8,0)
	else:
		spawn_position = Vector3(28,0.8,0)
	
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
	
	if not get_node("/root/Stage/Players/" + player.name):
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

# When a player dies, its team loses a life
puppet func player_died(team):	
	if team == "team_1":
		team_1_lifes-=1
	else:
		team_2_lifes-=1
	
	# Update the scoreboard
	scoreboard.text = String(team_1_lifes) + " - " + String(team_2_lifes)

#===============================================================================	
