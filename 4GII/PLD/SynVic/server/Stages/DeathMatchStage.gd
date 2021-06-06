extends Spatial

# id: team
var players = {}

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

#===============================================================================
#===============================================================================

func _ready():
	team_1_lifes = num_lifes
	team_2_lifes = num_lifes
	
	# Initialize the scoreboard
	scoreboard.text = String(team_1_lifes) + " - " + String(team_2_lifes)
	
	# These scripts need the node of the stage
	projectileSpawner.set_stage_node()
	areaSpawner.set_stage_node()

#===============================================================================

# TODO: Generic class stage with these functions, in this class only game rules
func spawn_player(team, id, player_name, player_character):
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
	
	player.transform.origin = spawn_position
	player.spawn_pos = spawn_position
	player.name = "P_" + String(id) # Important
	player.set_network_master(id) # Important
	player.set_team(team)
	player.player_name = player_name
	
	# Remember id and team
	players[id] = team
	
	$Players.add_child(player)

#===============================================================================

# When the match ends, the game transitions to the main menu
func game_ended(winner_team):
	print("¡HA GANADO LA PARTIDA EL EQUIPO " + winner_team + '!')
	
	var ids = players.keys()
	
	# Notify winners and losers
	for id in ids:
		if players[id] == winner_team:
			rpc_id(id, "finish_game", true)
		else:
			rpc_id(id, "finish_game", false)
	


# Change to main menu and free scenes
var player_finished = 0
remotesync func close_stage():
	print("Player asking to close")
	player_finished += 1
	if player_finished == 4:
		get_tree().get_root().get_node("Lobby").queue_free()
		get_node("/root/MainMenu").reload()
		get_node("/root/MainMenu").show()


remotesync func finish_game(winner):
	pass

#===============================================================================
# Rules
#===============================================================================

# When a player dies, its team loses a life
remote func player_died(team):
	rpc("player_died", team)
	if team == "team_1":
		team_1_lifes-=1
	else:
		team_2_lifes-=1
	
	print(team_2_lifes)
	
	# Update the scoreboard
	scoreboard.text = String(team_1_lifes) + " - " + String(team_2_lifes)
	
	# If a team has 0 lifes, the game is over
	if team_1_lifes <= 0:
		game_ended("team_2")
	elif team_2_lifes <= 0:
		game_ended("team_1")
		

#===============================================================================
