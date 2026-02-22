extends PanelContainer

## A single artist tier card showing name, level, production, and buy/upgrade buttons.

signal buy_pressed(tier: int)
signal upgrade_pressed(tier: int)

var _tier: int = ArtistData.ArtistTier.BUSKER

@onready var name_label: Label = %NameLabel
@onready var level_label: Label = %LevelLabel
@onready var production_label: Label = %ProductionLabel
@onready var count_label: Label = %CountLabel
@onready var buy_button: Button = %BuyButton
@onready var upgrade_button: Button = %UpgradeButton
@onready var icon_rect: TextureRect = %IconRect
@onready var lock_overlay: ColorRect = %LockOverlay

func setup(tier: int) -> void:
	_tier = tier

func _ready() -> void:
	GameManager.cds_changed.connect(_on_state_changed)
	GameManager.artist_purchased.connect(_on_artist_changed)
	GameManager.artist_leveled_up.connect(_on_artist_changed)
	buy_button.pressed.connect(func(): buy_pressed.emit(_tier))
	upgrade_button.pressed.connect(func(): upgrade_pressed.emit(_tier))
	_update_display()

func _on_state_changed(_val) -> void:
	_update_display()

func _on_artist_changed(_tier_val, _count_or_level) -> void:
	_update_display()

func _update_display() -> void:
	var data: Dictionary = ArtistData.TIERS[_tier]
	var unlocked := GameManager.is_artist_unlocked(_tier)
	var count := GameManager.get_artist_count(_tier)
	var level := GameManager.get_artist_level(_tier)

	name_label.text = data["name"]
	icon_rect.texture = load(data["sprite"])

	if not unlocked:
		lock_overlay.visible = true
		buy_button.disabled = true
		upgrade_button.disabled = true
		count_label.text = "Locked"
		level_label.text = "Need %s CDs" % GameConfig.format_number(data["unlock_threshold"])
		production_label.text = ""
		return

	lock_overlay.visible = false

	count_label.text = "Owned: %d" % count
	level_label.text = "Lv. %d" % level

	if count > 0:
		var prod := ArtistData.production_at_level(_tier, level) * count
		production_label.text = "%s/sec" % GameConfig.format_number(prod)
	else:
		production_label.text = "Not signed yet"

	# Buy button
	var buy_cost := ArtistData.purchase_cost(_tier, count)
	buy_button.text = "Sign (%s)" % GameConfig.format_number(buy_cost)
	buy_button.disabled = not GameManager.can_afford(buy_cost)

	# Upgrade button
	if count > 0 and level < ArtistData.MAX_LEVEL:
		var upgrade_cost := ArtistData.upgrade_cost(_tier, level)
		upgrade_button.text = "Level Up (%s)" % GameConfig.format_number(upgrade_cost)
		upgrade_button.disabled = not GameManager.can_afford(upgrade_cost)
		upgrade_button.visible = true
	else:
		upgrade_button.visible = false
