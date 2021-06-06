extends Node2D

# Scenes
#var stage : String
var stages = [
	"deathMatch",
	"capture"
]

# Default game port
const DEFAULT_PORT = 12345

# Max number of players
const MAX_PLAYERS = 4

# Players dict stored as id:name
var players = {}
var ready_players = []

# Character of each player id:string
var playersCharacters = {}

# Lobby
var LobbyScene = preload("res://Menus/Lobby.tscn")
var lobby

#===============================================================================
#===============================================================================

# Reset server
func reload():
	print("Resetting server")
	var ids = players.keys()
	print(ids)
	for id in ids:
		get_tree().network_peer.disconnect_peer(id)
		print("Player " + String(id) + " disconnected")
		
	players.clear()
	ready_players.clear()
	playersCharacters.clear()
	get_tree().set_network_peer(null)
	
	print("Reloading")
	if get_node("/root/Lobby"):
		get_node("/root/Lobby").queue_free()
	if get_node("/root/Stage"):
		get_node("/root/Stage").queue_free()
	
	create_server()

func _ready():
	# Network signals
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self,"_player_disconnected")
	
	create_server()

func create_server():
	var host = NetworkedMultiplayerENet.new()
	host.create_server(DEFAULT_PORT, MAX_PLAYERS)
	get_tree().set_network_peer(host)

#===============================================================================

func _player_connected(id):
	print("Client ", id, " connected")
	rset_id(id, "myID", id)

# Probably better to don't send this info
func _player_disconnected(id):
	if ready_players.has(id):
		ready_players.erase(id)
		rpc("unregister_player", id)
	
	print("Client ", id, " disconnected")

# Player management functions
remote func register_player(new_player_name, playerCharacter):
	# We get id this way instead of as parameter, to prevent users from pretending to be other users
	var caller_id = get_tree().get_rpc_sender_id()
	
	# If game is going -> TODO: Reconnect guy
	if not has_node("/root/Stage"):
		# Add him to our list
		players[caller_id] = new_player_name
		playersCharacters[caller_id] = playerCharacter
		
		# Add everyone to new player:
		for p_id in players:
			rpc_id(caller_id, "register_player", p_id, players[p_id], playersCharacters[p_id]) # Send each player to new dude
		
		rpc("register_player", caller_id, players[caller_id], playersCharacters[caller_id]) # Send new dude to all players
		# NOTE: this means new player's register gets called twice, but fine as same info sent both times
		
		print("Client ", caller_id, " registered as ", new_player_name, " with ", playerCharacter)

puppetsync func unregister_player(id):
	players.erase(id)
	
	print("Client ", id, " was unregistered")

#===============================================================================

remote func player_ready():
	var caller_id = get_tree().get_rpc_sender_id()
	
	if not ready_players.has(caller_id):
		ready_players.append(caller_id)
	
	# If all players are ready
	if ready_players.size() == MAX_PLAYERS:
		sort_players()
		randomize()
		pre_create_lobby(stages[(randi() % stages.size())])

func sort_players():
	var player_aux = {}
	var keys = players.keys()
	
	keys.sort()
	
	for k in keys:
		player_aux[k] = players[k]
	
	players = player_aux

#===============================================================================

# Create map
func pre_create_lobby(stage):
	lobby = LobbyScene.instance()
	lobby.init(stage, players, playersCharacters)
	get_tree().get_root().add_child(lobby)
	get_node("/root/MainMenu").hide()
	
	rpc("pre_create_lobby", stage)

# Add rest of players to every player
remote func post_create_lobby():
#	rpc("lobby.start_timer")
	pass
