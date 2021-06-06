extends Node2D

# Characters
var characters = [
	"Engineer",
	"Mage"
]
var myCharacter

# Game port and ip
puppet var myID
const ip = "127.0.0.1"
#const ip = "192.168.0.15"
const DEFAULT_PORT = 12345

# Max number of players
const MAX_PLAYERS = 4

# Players dict stored as id:name
var players = {}
var my_name
var playersCharacters = {}

# Signal to let GUI know whats up
signal connection_failed()
signal connection_succeeded()
signal server_disconnected()
signal players_updated()

# Attributes used to show for how long the user has been searching for a game
onready var time_searching_game = $Background/TimeSearchingGame
var elapsed_time:float = 0.0 # Time in seconds
var searching_for_game = false
var font = load("res://Fonts/new_dynamicfont.tres")

var lobby

#===============================================================================
#===============================================================================

func _ready():
	get_tree().connect("connected_to_server", self, "_connected_ok")
	get_tree().connect("connection_failed", self, "_connected_fail")
	get_tree().connect("server_disconnected", self, "_server_disconnected")

func _process(delta):
	# If the player has clicked on "Search Game", show how much time has passed
	if searching_for_game:
		elapsed_time += delta
		var elapsed_time_int = int(elapsed_time)
		
		# Format the text of the label
		var seconds = elapsed_time_int % 60
		var minutes = elapsed_time_int / 60
		
		# If minutes and/or seconds are smaller than 10, show a 0
		# as the first digit
		var seconds_text:String
		var minutes_text:String
		
		if seconds < 10:
			seconds_text = "0" + String(seconds)
		else:
			seconds_text = String(seconds)
			
		if minutes < 10:
			minutes_text = "0" + String(minutes)
		else:
			minutes_text = String(minutes)
		
		time_searching_game.text = minutes_text + ":" + seconds_text

func reload():
	get_tree().reload_current_scene()

#===============================================================================

# Connect to server when button pressed
func _on_SearchGameButton_pressed():
	# Remove lobby if already existed
	if get_node("/root/Lobby"):
		get_node("/root/Lobby").queue_free()
	if get_node("/root/Stage"):
		get_node("/root/Stage").queue_free()
	
	my_name = $Background/VBoxContainer/Name.text
	myCharacter = $Background/VBoxContainer/HBoxContainer/CharacterName.text
	$Background/VBoxContainer/SearchGameButton.disabled = true
	$Background/VBoxContainer/HBoxContainer/LeftButton.disabled = true
	$Background/VBoxContainer/HBoxContainer/RightButton.disabled = true
	
	# Initialize a "counter" (see _process method) that shows the client for how
	# long it has been searching for a game
	
	# Change size of font
	time_searching_game.text = ""
	font.size = 70
	time_searching_game.add_font_override("font", font)
	# Change text color so that it becomes visible
	time_searching_game.add_color_override("font_color", Color(1,1,1))
	
	elapsed_time = 0.0
	searching_for_game = true
	
	connect_to_server()

func connect_to_server():
	var host = NetworkedMultiplayerENet.new()
	host.create_client(ip, DEFAULT_PORT)
	get_tree().set_network_peer(host)

#===============================================================================

func _on_LeftButton_pressed():
	var actualCharacter = $Background/VBoxContainer/HBoxContainer/CharacterName.text
	var pos = characters.bsearch(actualCharacter)
	var previousPos = (pos - 1) % characters.size()
	$Background/VBoxContainer/HBoxContainer/CharacterName.text = characters[previousPos]

func _on_RightButton_pressed():
	var actualCharacter = $Background/VBoxContainer/HBoxContainer/CharacterName.text
	var pos = characters.bsearch(actualCharacter)
	var previousPos = (pos + 1) % characters.size()
	$Background/VBoxContainer/HBoxContainer/CharacterName.text = characters[previousPos]

#===============================================================================

# Callback from SceneTree, called when connect to server
func _connected_ok():
	print("Connected")
	if lobby:
		lobby.queue_free()
	emit_signal("connection_succeeded")
	
	# Register ourselves with the server
	rpc_id(1, "register_player", my_name, myCharacter)
	rpc_id(1, "player_ready")

# Callback from SceneTree, called when server disconnect
func _server_disconnected():
	players.clear()
	emit_signal("server_disconnected")
	
	# Try to connect again
	connect_to_server()

# Callback from SceneTree, called when unabled to connect to server
func _connected_fail():
	print("Could not connect")
	get_tree().set_network_peer(null) # Remove peer
	emit_signal("connection_failed")
	
	$Background/VBoxContainer/SearchGameButton.disabled = false
	$Background/VBoxContainer/HBoxContainer/LeftButton.disabled = false
	$Background/VBoxContainer/HBoxContainer/RightButton.disabled = false
	
	# Change size of font
	font.size = 20
	time_searching_game.add_font_override("font", font)
	time_searching_game.text = "Failed to connect with server\nPlease try again"
	searching_for_game = false

#===============================================================================

# Returns list of player names
func get_player_list():
	return players.values()

puppet func register_player(id, new_player_data, playerCharacter):
	players[id] = new_player_data
	playersCharacters[id] = playerCharacter
	print("Player ", id, " registered as ", new_player_data, " with ", playerCharacter)
	emit_signal("players_updated")

puppet func unregister_player(id):
	players.erase(id)
	emit_signal("players_updated")

#===============================================================================

func sort_players():
	var player_aux = {}
	var keys = players.keys()
	
	keys.sort()
	
	for k in keys:
		player_aux[k] = players[k]
	
	players = player_aux

# Load map
puppet func pre_create_lobby(stage):
	sort_players()
	get_node("/root/MainMenu").hide()
	
	lobby = load("res://Menus/Lobby.tscn").instance()
	lobby.init(stage, players, playersCharacters, myID)
	lobby.set_network_master(1)
	get_tree().get_root().add_child(lobby)
	
	rpc_id(1, "post_create_lobby")

# Load scene to show characters info
func _on_CharactersButton_pressed():
	get_tree().change_scene("res://Menus/CharactersInfo.tscn")

# Load scene to change the audio options
func _on_AudioButton_pressed():
	get_tree().change_scene("res://Menus/AudioMenu.tscn")
