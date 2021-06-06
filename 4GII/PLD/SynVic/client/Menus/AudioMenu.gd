extends Node2D

# Buttons
onready var master_volume_button = $Background/MasterVolumeButton
onready var music_volume_button = $Background/MusicVolumeButton
onready var effects_volume_button = $Background/EffectsVolumeButton

# Sliders
onready var master_volume_slider = $Background/MasterVolumeSlider
onready var music_volume_slider = $Background/MusicVolumeSlider
onready var effects_volume_slider = $Background/EffectsVolumeSlider

# --------------------------------------------------

# Load the saved audio configuration from audio_config.gd
func _ready():
	# Buttons
	master_volume_button.set_pressed(audio_config.master_volume_enabled)
	music_volume_button.set_pressed(audio_config.music_volume_enabled)
	effects_volume_button.set_pressed(audio_config.effects_volume_enabled)
	
	# Sliders
	master_volume_slider.set_value(audio_config.master_volume_level)
	music_volume_slider.set_value(audio_config.music_volume_level)
	effects_volume_slider.set_value(audio_config.effects_volume_level)

# --------------------------------------------------

# Return to Main Menu
func _on_MainMenuButton_pressed():
	get_tree().change_scene("res://Menus/MainMenu.tscn")

# --------------------------------------------------
# Buttons
# --------------------------------------------------

func _on_MasterVolumeButton_pressed():
	# Change attribute in global script "audio_config"
	audio_config.master_volume_enabled = master_volume_button.is_pressed()

func _on_MusicVolumeButton_pressed():
	# Change attribute in global script "audio_config"
	audio_config.music_volume_enabled = music_volume_button.is_pressed()

func _on_EffectsVolumeButton_pressed():
	# Change attribute in global script "audio_config"
	audio_config.effects_volume_enabled = effects_volume_button.is_pressed()

# --------------------------------------------------
# Sliders
# --------------------------------------------------

func _on_MasterVolumeSlider_value_changed(value):
	# Change attribute in global script "audio_config"
	audio_config.master_volume_level = value

func _on_MusicVolumeSlider_value_changed(value):
	# Change attribute in global script "audio_config"
	audio_config.music_volume_level = value

func _on_EffectsVolumeSlider_value_changed(value):
	# Change attribute in global script "audio_config"
	audio_config.effects_volume_level = value
