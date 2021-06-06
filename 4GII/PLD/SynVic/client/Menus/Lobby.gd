extends Node2D

var players # id:name
# Dict: id:character
var playersCharacters = {
	13413: "Mage",
	13432: "Engineer",
	41243: "Assassin",
	55124: "Bard",
}
var playersIDs  # list
var myID = 4

# Scenes
var stage
var stages = {
	"deathMatch" : "res://Stages/DeathMatchStage.tscn",
	"capture" : "res://Stages/Capture/CaptureStage.tscn"
}

# IDs of players voted
var myVoteUp = -1
var myVoteDown = -1

onready var layout = [
	$Background/VBox/Players/VBox/Player1,
	$Background/VBox/Players/VBox/Player2,
	$Background/VBox/Players/VBox2/Player3,
	$Background/VBox/Players/VBox2/Player4,
]

var buttonsUp = [
	"Background/VBox/Players/VBox/Player1/UpButton",
	"Background/VBox/Players/VBox/Player2/UpButton",
	"Background/VBox/Players/VBox2/Player3/UpButton",
	"Background/VBox/Players/VBox2/Player4/UpButton"
]

var buttonsDown = [
	"Background/VBox/Players/VBox/Player1/DownButton",
	"Background/VBox/Players/VBox/Player2/DownButton",
	"Background/VBox/Players/VBox2/Player3/DownButton",
	"Background/VBox/Players/VBox2/Player4/DownButton"
]

var pressedUpButtons = [false,false,false,false]
var pressedDownButtons = [false,false,false,false]

var portraits = {
	"Engineer" : "res://assets/Lobby/Engineer.jpg",
	"Mage" : "res://assets/Lobby/Mage.jpg"
}

#===============================================================================
#===============================================================================

func init(stag, play, playersCharact, id):
	stage = stag
	$Background/Mode.text = stag
	myID = id
	playersCharacters = playersCharact
	players = play
	
	var ids = players.keys()
	$Background/VBox/Players/VBox/Player1/Portrait.texture = load(portraits[playersCharacters[ids[0]]])
	$Background/VBox/Players/VBox/Player2/Portrait.texture = load(portraits[playersCharacters[ids[1]]])
	$Background/VBox/Players/VBox2/Player3/Portrait.texture = load(portraits[playersCharacters[ids[2]]])
	$Background/VBox/Players/VBox2/Player4/Portrait.texture = load(portraits[playersCharacters[ids[3]]])
	
	playersIDs = ids

func _ready():
	# Disable buttons for the player
	var pos = players.keys().bsearch(myID)
	var lay = layout[pos]
	lay.get_node("UpButton").disabled = true
	lay.get_node("DownButton").disabled = true
	
	# Set each player character name
	for i in range(players.size()):
		layout[i].get_node("CharacterName").text = players.values()[i]
		
	$Background/Timer.start(30)

remote func start_timer():
	$Background/Timer.start(30)

#===============================================================================

remotesync func vote(id, voteUp, voteDown):
	pass

# Notify server about votes
func _on_CastVoteButton_pressed():
	print("Player ", myID, " votesUp ", myVoteUp, " votesDown ", myVoteDown)
	$Background/VBox/CastVoteButton.disabled = true
	rpc_id(1, "vote", myID, myVoteUp, myVoteDown)

# Same as above, notify server about votes
func _on_Timer_timeout():
	print("Player ", myID, " votesUp ", myVoteUp, " votesDown ", myVoteDown)
	$Background/VBox/CastVoteButton.disabled = true
	rpc_id(1, "vote", myID, myVoteUp, myVoteDown)

#===============================================================================

# Player: 1 .. 4
# firstTime = if the player pressed the button or not
func _on_pressedUp(player, firstTime = true):
	player -= 1
	
	if pressedUpButtons[player]: # If it was pressed
		myVoteUp = -1
		get_node(buttonsUp[player]).set_modulate(Color(1,1,1))
		pressedUpButtons[player] = false
	elif firstTime:
		myVoteUp = playersIDs[player]
		pressedUpButtons[player] = true
		get_node(buttonsUp[player]).set_modulate(Color(0.521569, 0.894118, 0.215686))
	
	# Set other up buttons to normal
	for i in range(players.size()):
		if i != player:
			get_node(buttonsUp[i]).set_modulate(Color(1,1,1))
	
	# If the same player down button was pressed, remove it
	if pressedDownButtons[player] and firstTime:
		_on_pressedDown(player+1, false)

# Player: 1 .. 4
# firstTime = if the player pressed the button or not
func _on_pressedDown(player, firstTime = true):
	player -= 1
	
	if pressedDownButtons[player]: # If it was pressed
		myVoteDown = -1
		get_node(buttonsDown[player]).set_modulate(Color(1,1,1))
		pressedDownButtons[player] = false
	elif firstTime:
		myVoteDown = playersIDs[player]
		get_node(buttonsDown[player]).set_modulate(Color(0.913725, 0.356863, 0.356863))
		pressedDownButtons[player] = true
	
	# Set other down buttons to normal
	for i in range(players.size()):
		if i != player:
			get_node(buttonsDown[i]).set_modulate(Color(1,1,1))
	
	# If the same player up button was pressed, remove it
	if pressedUpButtons[player] and firstTime:
		_on_pressedUp(player+1, false)

#===============================================================================

# Load map
puppet func pre_start_game():
	if get_node("/root/Lobby/Background"): 
		get_node("/root/Lobby/Background").queue_free()
		
	var map = load(stages[stage]).instance()
	get_tree().get_root().add_child(map)
	
	rpc_id(1, "post_start_game")
