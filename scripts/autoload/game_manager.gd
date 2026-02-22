extends Node

## Core game state singleton. Holds all player data and emits signals on changes.

# Signals
signal cds_changed(new_amount: float)
signal artist_purchased(artist_tier: int)
signal upgrade_purchased(upgrade_id: String)

# Player state
var cds: float = 0.0
var total_cds_earned: float = 0.0
var artists_owned: Dictionary = {}  # {tier_id: count}
var artist_levels: Dictionary = {}  # {tier_id: level}
var studio_upgrades: Dictionary = {}  # {upgrade_id: level}
var last_save_timestamp: float = 0.0

func _ready() -> void:
	print("GameManager loaded")

func add_cds(amount: float) -> void:
	cds += amount
	total_cds_earned += amount
	cds_changed.emit(cds)

func spend_cds(amount: float) -> bool:
	if cds >= amount:
		cds -= amount
		cds_changed.emit(cds)
		return true
	return false
