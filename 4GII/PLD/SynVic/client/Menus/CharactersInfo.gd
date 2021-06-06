extends Node2D

var num_characters:int = 2

# Character whose information is currently being shown
var curr_character:int = 0

# Information of each character (in the order given by "characters" array)
var character_names = ["Engineer", "Mage"]

var character_descriptions = ["The Engineer is a long-range, high-damage character that shoots different types of projectiles. At the same\n" + \
"time, she is very immobile and weak. For this reason, her gameplay revolves  around running away from her\n" + \
"enemies and then attacking them from a save distance.",
"The Mage is a tank support that specializes in map control, protecting his ally from the enemies. His gameplay\n" + \
"revolves around positioning: he must keep his ally far from the enemies and, at the same time, he must be in\n" + \
"the middle of the same enemies, preventing them from reaching his ally."]

var basic_descriptions = ["She shoots an enemy with her crossbow, dealing little damage.\n" + \
"This attack has long range and can be casted while moving.",
"He hits an enemy with his staff. This attack has low range and damage, but\n" + \
"invokes ice to apply a small slowness debuff."]

var q_descriptions = ["She uses her gun to shoot a bullet that will traverse the map until it hits\n" + \
"an enemy or wall.",
"He invokes a random element on a zone, which applies a debuff to every\n" + \
"enemy or ally projectile that touches it: ice - slowness, fire - dmg per second\n" + \
"poison - more dmg received."]

var w_descriptions = ["She shoots a hook which, after hitting a wall, pulls the Engineer towards it.\n" + \
"This skill has long CD.",
"He swaps positions with his ally."]

var e_descriptions = ["She shoots a slow grenade that bounces on walls. After hitting an enemy or\n" + \
"reaching the maximum number of bounces, the grenade explodes, dealing\n" + \
"AoE damage. There can be up to 3 grenades in the game at the same time.",
"After pressing the 'E' key twice with the mouse in different positions, the\n" + \
"Mage builds a wall between the two points that doesn't disappear after he\n" + \
"builds another one."]

var r_descriptions = ["After a 4-second casting, she takes out her giant gun which she can use to shoot\n" + \
"up to 10 times. These shots have unlimited range and go through everything,\n" + \
"dealing medium damage to every enemy they hit. If the Engineer receives CC or moves\n" + \
"during the casting or skill time, the skill resets and the CD starts from 0.",
"After a long casting time (during which the Mage cannot execute any actions),\n" + \
"he invokes a thunderstorm that stuns enemies in an area around him for 5\n" + \
"seconds."]

# Labels
onready var character_name_label = $Background/HBoxContainer/HBoxContainer/CharacterName
onready var character_description_label = $Background/CharacterDescription
onready var basic_description_label = $Background/BasicAttackDescription
onready var q_description_label = $Background/QDescription
onready var w_description_label = $Background/WDescription
onready var e_description_label = $Background/EDescription
onready var r_description_label = $Background/RDescription

func _ready():
	set_text_labels()
	
# ----------------------------

# Sets the text of the labels that correspond to the current character
func set_text_labels():
	character_name_label.text = character_names[curr_character]
	character_description_label.text = character_descriptions[curr_character]
	basic_description_label.text = basic_descriptions[curr_character]
	q_description_label.text = q_descriptions[curr_character]
	w_description_label.text = w_descriptions[curr_character]
	e_description_label.text = e_descriptions[curr_character]
	r_description_label.text = r_descriptions[curr_character]

# ----------------------------
# Change Character Info being displayed

func _on_LeftButton_pressed():
	curr_character = (curr_character - 1) % num_characters
	set_text_labels()

func _on_RightButton_pressed():
	curr_character = (curr_character + 1) % num_characters
	set_text_labels()

# ----------------------------

# Return to Main Menu
func _on_MainMenuButton_pressed():
	get_tree().change_scene("res://Menus/MainMenu.tscn")
