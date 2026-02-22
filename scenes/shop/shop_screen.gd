extends Control

## Shop screen — ad rewards and future IAP.

@onready var nav_bar: PanelContainer = %NavBar
@onready var boost_button: Button = %BoostButton
@onready var status_label: Label = %StatusLabel

func _ready() -> void:
	nav_bar.screen_requested.connect(_on_screen_requested)
	boost_button.pressed.connect(_on_boost_pressed)
	_update_display()

func _process(_delta: float) -> void:
	_update_display()

func _update_display() -> void:
	var remaining := GameManager.get_boost_time_remaining()
	if remaining > 0:
		status_label.text = "2x Boost active: %ds remaining" % int(remaining)
		boost_button.disabled = true
	else:
		status_label.text = "No active boosts"
		boost_button.disabled = false

func _on_boost_pressed() -> void:
	# TODO: Replace with actual AdMob rewarded ad call
	# For now, simulate watching an ad
	GameManager.activate_boost(GameConfig.AD_BOOST_MULTIPLIER, GameConfig.AD_BOOST_DURATION)
	status_label.text = "Boost activated!"

func _on_screen_requested(screen_name: String) -> void:
	match screen_name:
		"main":
			get_tree().change_scene_to_file("res://scenes/main/main_screen.tscn")
		"artists":
			get_tree().change_scene_to_file("res://scenes/artists/artist_screen.tscn")
		"studio":
			get_tree().change_scene_to_file("res://scenes/studio/studio_screen.tscn")
		"casino":
			get_tree().change_scene_to_file("res://scenes/casino/casino_screen.tscn")
