# Global Script that stores audio configuration (volume)

extends Node

# Master Volume
var master_volume_enabled:bool = true
var master_volume_level:float = 0.5

# Music Volume
var music_volume_enabled:bool = true
var music_volume_level:float = 0.5

# Effects Volume
var effects_volume_enabled:bool = true
var effects_volume_level:float = 0.5

# -------------------------------------------------

# Uses master_volume_level and music_volume_level to return the
# decibels for the music volume
func get_music_db():
	var level_coeff = 0.5 # If I don't use this, the sound is too high
	var total_level = master_volume_level*music_volume_level*level_coeff
	var total_db = linear2db(total_level)
	
	return total_db
	
# Uses master_volume_level and effects_volume_level to return the
# decibels for the effects volume
func get_effects_db():
	var level_coeff = 100 # If I don't use this, the sound is too low
	var total_level = master_volume_level*effects_volume_level*level_coeff
	var total_db = linear2db(total_level)
	
	return total_db
