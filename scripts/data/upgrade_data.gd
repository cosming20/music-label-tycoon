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
		"effect_per_level": 0.05,
		"sprite": "res://assets/sprites/studio/icon_recording_quality.png",
	},
	UpgradeId.MARKETING_REACH: {
		"name": "Marketing Reach",
		"description": "Higher tier CDs appear more often",
		"base_cost": 200.0,
		"cost_growth": 1.5,
		"max_level": 50,
		"effect_per_level": 0.03,
		"sprite": "res://assets/sprites/studio/icon_marketing_reach.png",
	},
}

## Calculate cost for upgrading to next level.
static func cost_at_level(upgrade_id: int, current_level: int) -> float:
	var data: Dictionary = UPGRADES[upgrade_id]
	return data["base_cost"] * pow(data["cost_growth"], current_level)
