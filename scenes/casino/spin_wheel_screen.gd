extends Control

@onready var nav_bar: PanelContainer = %NavBar

func _ready() -> void:
	nav_bar.screen_requested.connect(func(s):
		if s == "casino":
			get_tree().change_scene_to_file("res://scenes/casino/casino_screen.tscn")
		else:
			get_tree().change_scene_to_file("res://scenes/main/main_screen.tscn"))
