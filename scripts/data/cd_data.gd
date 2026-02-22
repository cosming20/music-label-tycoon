class_name CdData
extends RefCounted

## Static data for all CD tiers.

enum CdTier {
	DEMO = 1,
	SINGLE = 2,
	EP = 3,
	ALBUM = 4,
	PLATINUM = 5,
	DIAMOND = 6,
}

## CD tier definition: value, drop weight, display name, color
const TIERS: Dictionary = {
	CdTier.DEMO: {
		"name": "Demo CD",
		"value": 1,
		"drop_weight": 100,  # Relative weight for spawn probability
		"color": Color.SILVER,
		"description": "A basic demo recording",
	},
	CdTier.SINGLE: {
		"name": "Single",
		"value": 5,
		"drop_weight": 50,
		"color": Color.CORNFLOWER_BLUE,
		"description": "A hit single release",
	},
	CdTier.EP: {
		"name": "EP",
		"value": 25,
		"drop_weight": 20,
		"color": Color.GREEN,
		"description": "An extended play collection",
	},
	CdTier.ALBUM: {
		"name": "Album",
		"value": 150,
		"drop_weight": 5,
		"color": Color.GOLD,
		"description": "A full studio album",
	},
	CdTier.PLATINUM: {
		"name": "Platinum",
		"value": 1000,
		"drop_weight": 1,
		"color": Color.WHITE_SMOKE,
		"description": "A platinum-certified record",
	},
	CdTier.DIAMOND: {
		"name": "Diamond",
		"value": 10000,
		"drop_weight": 0.1,
		"color": Color.CYAN,
		"description": "A legendary diamond record",
	},
}

## Returns total drop weight for probability calculations.
static func total_drop_weight() -> float:
	var total := 0.0
	for tier_data in TIERS.values():
		total += tier_data["drop_weight"]
	return total

## Picks a random CD tier based on weighted probability.
static func pick_random_tier() -> int:
	var roll := randf() * total_drop_weight()
	var cumulative := 0.0
	for tier_id in TIERS:
		cumulative += TIERS[tier_id]["drop_weight"]
		if roll <= cumulative:
			return tier_id
	return CdTier.DEMO  # Fallback
