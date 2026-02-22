extends Control

## Artist roster screen — lists all artist tiers with buy/upgrade controls.

@onready var scroll: ScrollContainer = %ScrollContainer
@onready var artist_list: VBoxContainer = %ArtistList
@onready var nav_bar: PanelContainer = %NavBar

var _card_scene: PackedScene

func _ready() -> void:
	_card_scene = preload("res://scenes/artists/artist_card.tscn")
	nav_bar.screen_requested.connect(_on_screen_requested)
	_build_artist_list()

func _build_artist_list() -> void:
	# MVP: only first 3 tiers
	var mvp_tiers := [
		ArtistData.ArtistTier.BUSKER,
		ArtistData.ArtistTier.GARAGE_BAND,
		ArtistData.ArtistTier.INDIE_ARTIST,
	]
	for tier in mvp_tiers:
		var card := _card_scene.instantiate()
		card.setup(tier)
		card.buy_pressed.connect(_on_buy_artist)
		card.upgrade_pressed.connect(_on_upgrade_artist)
		artist_list.add_child(card)

func _on_buy_artist(tier: int) -> void:
	GameManager.buy_artist(tier)

func _on_upgrade_artist(tier: int) -> void:
	GameManager.upgrade_artist(tier)

func _on_screen_requested(screen_name: String) -> void:
	SceneRouter.go_to(screen_name)
