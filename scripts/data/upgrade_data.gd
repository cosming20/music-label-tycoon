class_name UpgradeData
extends RefCounted

## Static data for studio upgrades.

enum UpgradeId {
	RECORDING_QUALITY,
	MARKETING_REACH,
}

const UPGRADES: Dictionary = {
	UpgradeId.RECORDING_QUALITY: {
		"name": "Recording Quality",
		"description": "All artist production +5% per level",
		"base_cost": 100.0,
		"cost_growth": 1.5,
		"max_level": 50,
		"effect_per_level": 0.05,  # 5% production boost
		"icon_color": Color.RED,
	},
	UpgradeId.MARKETING_REACH: {
		"name": "Marketing Reach",
		"description": "Higher tier CDs appear more often",
		"base_cost": 200.0,
		"cost_growth": 1.5,
		"max_level": 50,
		"effect_per_level": 0.03,  # 3% shift toward higher tiers
		"icon_color": Color.BLUE,
	},
}

## Calculate cost for upgrading to next level.
static func cost_at_level(upgrade_id: int, current_level: int) -> float:
	var data: Dictionary = UPGRADES[upgrade_id]
	return data["base_cost"] * pow(data["cost_growth"], current_level)
