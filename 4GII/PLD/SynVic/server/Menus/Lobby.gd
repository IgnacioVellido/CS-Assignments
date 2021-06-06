extends Node2D

var playersVotes = {}       # id:[voteUp, voteDown] vote = pos, not id
var players                 # id:name
var playersCharacters = {}  # Character of each player id:string

var teams
var restrictions = []

# Scenes
var stage : String
var stages = {
	"deathMatch" : "res://Stages/DeathMatchStage.tscn",
	"capture" : "res://Stages/Capture/CaptureStage.tscn"
}

var game_started = false

#===============================================================================
#===============================================================================

func init(stag, play, playCh):
	stage = stag
	players = play
	playersCharacters = playCh
	game_started = false

remotesync func start_timer():
	pass

#===============================================================================

remotesync func vote(id, voteUp, voteDown):
	print("Player ", id, " votesUp ", voteUp, " votesDown ", voteDown)
	playersVotes[id] = [voteUp, voteDown]
	
	if playersVotes.size() == playersCharacters.size() and not game_started:
		game_started = true
		create_teams()
		pre_start_game()

#-------------------------------------------------------------------------------

func infeasibility(solution):
	var inf = 0
	
	for rest in restrictions:
		if rest[0] == 1 and solution[players.keys().bsearch(rest[1])] != solution[players.keys().bsearch(rest[2])]:
			inf += 1
		if rest[0] == -1 and solution[players.keys().bsearch(rest[1])] == solution[players.keys().bsearch(rest[2])]:
			inf += 1
	
	return inf

#-------------------------------------------------------------------------------

# [+-1, id, id]
func create_restrictions():
	var ids = players.keys()
	
	for id in ids:
		if playersVotes[id][0] != -1:
			restrictions.append([1, id, playersVotes[id][0]])
		if playersVotes[id][1] != -1:
			restrictions.append([-1, id, playersVotes[id][1]])

#-------------------------------------------------------------------------------

# Clustering problem -> solution = [team, team, team, team]
# Because there are only 4 players -> Brute force, check every combination
func create_teams():
	create_restrictions()
	
	# 1&2, 3&4
	var inf1 = infeasibility([1,1,2,2])
	
	# 1&3, 2&4
	var inf2 = infeasibility([1,2,1,2])
	
	# 1&4, 2&3
	var inf3 = infeasibility([1,2,2,1])
	
	teams = [1,1,2,2]
	var min_inf = inf1
	if inf1 > inf2:
		min_inf = inf2
		teams = [1,2,1,2]
	
	if min_inf > inf3:
		min_inf = inf3
		teams = [1,2,2,1]

#===============================================================================

# Create map
func pre_start_game():
	var map = load(stages[stage]).instance()
	get_tree().get_root().add_child(map)
	
	# Spawn all the people
	print(teams)
	var i = 0
	for id in players.keys():
		map.spawn_player("team_" + String(teams[i]), id, players[id], playersCharacters[id]) # Team, id
		i += 1
	
	rpc("pre_start_game")

# Add rest of players to every player
remote func post_start_game():
	var caller_id = get_tree().get_rpc_sender_id()
	var map = get_node("/root/Stage")
	
	for player in map.get_node("Players").get_children():
		if not "Dummy" in player.name:
			map.rpc_id(caller_id, "spawn_player", player.team, 
						player.get_network_master(), 
						players[player.get_network_master()],
						playersCharacters[player.get_network_master()])
	
	# Set enemies
	for player in map.get_node("Players").get_children():
		player.rpc_id(caller_id, "connect_enemies")
