extends Node2D

func _on_MainMenuButton_pressed():
	# Return to Main Menu
	if get_node("/root/Stage"):
		get_node("/root/Stage").queue_free()
	
	get_tree().change_scene("res://Menus/MainMenu.tscn")
	self.queue_free()
