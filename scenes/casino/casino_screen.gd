extends Control

## Casino hub — shows available gambling games.

@onready var nav_bar: PanelContainer = %NavBar
@onready var game_container: VBoxContainer = %GameContainer

func _ready() -> void:
	nav_bar.screen_requested.connect(_on_screen_requested)
	_setup_games()

func _setup_games() -> void:
	# Spin Wheel — always available
	var spin_wheel_btn := Button.new()
	spin_wheel_btn.text = "Daily Spin Wheel"
	spin_wheel_btn.pressed.connect(func():
		get_tree().change_scene_to_file("res://scenes/casino/spin_wheel_screen.tscn"))
	game_container.add_child(spin_wheel_btn)

	# Gacha — unlock at 1K total CDs
	var gacha_btn := Button.new()
	gacha_btn.text = "Mystery Crate"
	if GameManager.total_cds_earned < GameConfig.GACHA_UNLOCK:
		gacha_btn.text += " (Locked: %s CDs needed)" % GameConfig.format_number(GameConfig.GACHA_UNLOCK)
		gacha_btn.disabled = true
	gacha_btn.pressed.connect(func():
		get_tree().change_scene_to_file("res://scenes/casino/gacha_screen.tscn"))
	game_container.add_child(gacha_btn)

func _on_screen_requested(screen_name: String) -> void:
	match screen_name:
		"main":
			get_tree().change_scene_to_file("res://scenes/main/main_screen.tscn")
		"artists":
			get_tree().change_scene_to_file("res://scenes/artists/artist_screen.tscn")
		"studio":
			get_tree().change_scene_to_file("res://scenes/studio/studio_screen.tscn")
		"shop":
			get_tree().change_scene_to_file("res://scenes/shop/shop_screen.tscn")
