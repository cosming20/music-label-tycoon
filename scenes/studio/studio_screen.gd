extends Control

## Studio upgrades screen.

@onready var upgrade_list: VBoxContainer = %UpgradeList
@onready var nav_bar: PanelContainer = %NavBar

var _card_scene: PackedScene

func _ready() -> void:
	_card_scene = preload("res://scenes/studio/upgrade_card.tscn")
	nav_bar.screen_requested.connect(_on_screen_requested)
	_build_upgrade_list()

func _build_upgrade_list() -> void:
	for upgrade_id in UpgradeData.UPGRADES:
		var card := _card_scene.instantiate()
		card.setup(upgrade_id)
		card.purchase_pressed.connect(_on_upgrade_purchased)
		upgrade_list.add_child(card)

func _on_upgrade_purchased(upgrade_id: int) -> void:
	GameManager.buy_upgrade(upgrade_id)

func _on_screen_requested(screen_name: String) -> void:
	match screen_name:
		"main":
			get_tree().change_scene_to_file("res://scenes/main/main_screen.tscn")
		"artists":
			get_tree().change_scene_to_file("res://scenes/artists/artist_screen.tscn")
		"casino":
			get_tree().change_scene_to_file("res://scenes/casino/casino_screen.tscn")
		"shop":
			get_tree().change_scene_to_file("res://scenes/shop/shop_screen.tscn")
