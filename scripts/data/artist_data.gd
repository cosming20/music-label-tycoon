class_name ArtistData
extends RefCounted

## Static data for all artist tiers.

enum ArtistTier {
	BUSKER = 1,
	GARAGE_BAND = 2,
	INDIE_ARTIST = 3,
	STUDIO_PRO = 4,
	CHART_TOPPER = 5,
	SUPERSTAR = 6,
	LEGEND = 7,
}

const TIERS: Dictionary = {
	ArtistTier.BUSKER: {
		"name": "Street Busker",
		"base_cost": 50.0,
		"base_production": 1.0,  # CDs per second
		"unlock_threshold": 0.0,  # Total CDs earned to unlock
		"color": Color.SANDY_BROWN,
		"description": "A humble street performer",
	},
	ArtistTier.GARAGE_BAND: {
		"name": "Garage Band",
		"base_cost": 500.0,
		"base_production": 8.0,
		"unlock_threshold": 200.0,
		"color": Color.SLATE_BLUE,
		"description": "A scrappy garage rock outfit",
	},
	ArtistTier.INDIE_ARTIST: {
		"name": "Indie Artist",
		"base_cost": 5000.0,
		"base_production": 50.0,
		"unlock_threshold": 5000.0,
		"color": Color.MEDIUM_PURPLE,
		"description": "A rising indie sensation",
	},
	ArtistTier.STUDIO_PRO: {
		"name": "Studio Pro",
		"base_cost": 50000.0,
		"base_production": 400.0,
		"unlock_threshold": 50000.0,
		"color": Color.ORANGE_RED,
		"description": "A seasoned studio professional",
	},
	ArtistTier.CHART_TOPPER: {
		"name": "Chart Topper",
		"base_cost": 500000.0,
		"base_production": 3500.0,
		"unlock_threshold": 500000.0,
		"color": Color.HOT_PINK,
		"description": "A chart-dominating hitmaker",
	},
	ArtistTier.SUPERSTAR: {
		"name": "Superstar",
		"base_cost": 5000000.0,
		"base_production": 30000.0,
		"unlock_threshold": 5000000.0,
		"color": Color.GOLD,
		"description": "A global music superstar",
	},
	ArtistTier.LEGEND: {
		"name": "Legend",
		"base_cost": 50000000.0,
		"base_production": 250000.0,
		"unlock_threshold": 50000000.0,
		"color": Color.DARK_VIOLET,
		"description": "An immortal music legend",
	},
}

## Cost growth factor per additional artist of same tier.
const COST_GROWTH_RATE := 1.15

## Level upgrade cost growth factor.
const LEVEL_COST_GROWTH := 1.15

## Maximum artist level.
const MAX_LEVEL := 100

## Milestone levels and their multipliers.
const MILESTONES: Dictionary = {
	25: 2.0,
	50: 3.0,
	75: 4.0,
	100: 5.0,
}

## Production boost per level (10%).
const LEVEL_PRODUCTION_BOOST := 0.10

## Calculate cost to buy the Nth artist of a tier.
static func purchase_cost(tier: int, owned_count: int) -> float:
	var base: float = TIERS[tier]["base_cost"]
	return base * pow(COST_GROWTH_RATE, owned_count)

## Calculate cost to upgrade an artist to the next level.
static func upgrade_cost(tier: int, current_level: int) -> float:
	var base: float = TIERS[tier]["base_cost"]
	return base * pow(LEVEL_COST_GROWTH, current_level) * 0.5

## Calculate production for an artist at a given level.
static func production_at_level(tier: int, level: int) -> float:
	var base: float = TIERS[tier]["base_production"]
	var level_boost := 1.0 + (level * LEVEL_PRODUCTION_BOOST)
	var milestone_mult := 1.0
	for milestone_level in MILESTONES:
		if level >= milestone_level:
			milestone_mult = MILESTONES[milestone_level]
	return base * level_boost * milestone_mult
