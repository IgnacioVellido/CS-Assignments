extends Spatial

# id: team
var players = {}

# Score
var team_1_score : int = 0
var team_2_score : int = 0

# GUI
onready var scoreboard = $Scoreboard

# Main Menu
var main_menu_scene = "res://Menus/MainMenu.tscn"
const Engineer = preload('res://Characters/Engineer.tscn')
const Mage = preload('res://Characters/Mage.tscn')

#===============================================================================
#===============================================================================

func _ready():
	# Initialize the scoreboard
	update_scoreboard()
	
	# Start the timer with 5 minutes
	$Timer.start()
	
	# These scripts need the node of the stage
	projectileSpawner.set_stage_node()
	areaSpawner.set_stage_node()

#===============================================================================

# TODO: Generic class stage with these functions, in this class only game rules
func spawn_player(team, id, player_name, player_character):
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
remote func game_ended():
	var ids = players.keys()
	
	# Show the winner of the match
	if team_1_score > team_2_score:
		print("¡HA GANADO LA PARTIDA EL EQUIPO 1!")
		
		# Notify winners and losers
		for id in ids:
			if players[id] == "team_1":
				rpc_id(id, "finish_game", true)
			else:
				rpc_id(id, "finish_game", false)
		
	elif team_1_score < team_2_score:
		print("¡HA GANADO LA PARTIDA EL EQUIPO 2!")
		
		# Notify winners and losers
		for id in ids:
			if players[id] == "team_2":
				rpc_id(id, "finish_game", true)
			else:
				rpc_id(id, "finish_game", false)
	else:
		print("¡LA PARTIDA HA SIDO UN EMPATE!")
		
		# Notify winners and losers
		for id in ids:
			rpc_id(id, "finish_game", true)
	

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

# Adds points to the corresponding team (a player of that team is inside the area)
remote func add_points(team, points):
	if team == "team_1":
		team_1_score += points
	else:
		team_2_score += points
	
	rpc("add_points", team, points)
	
	# Update the scoreboard
	update_scoreboard()
	
# Updates the scoreboard with the points of both teams
func update_scoreboard():
	var score_text = String(team_1_score) + " - " + String(team_2_score)
	scoreboard.text = score_text
