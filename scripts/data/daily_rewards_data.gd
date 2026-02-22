class_name DailyRewardsData
extends RefCounted

## Daily login streak reward definitions.

const REWARDS: Array = [
	{"day": 1, "type": "cds", "amount": 100, "label": "100 CDs"},
	{"day": 2, "type": "cds", "amount": 250, "label": "250 CDs"},
	{"day": 3, "type": "boost", "duration": 60, "label": "60s 2x Boost"},
	{"day": 4, "type": "cds", "amount": 500, "label": "500 CDs"},
	{"day": 5, "type": "cds", "amount": 1000, "label": "1000 CDs"},
	{"day": 6, "type": "boost", "duration": 120, "label": "120s 2x Boost"},
	{"day": 7, "type": "cds", "amount": 5000, "label": "5000 CDs (Jackpot!)"},
]

static func apply_reward(day_index: int) -> String:
	var idx := clampi(day_index - 1, 0, REWARDS.size() - 1)
	var reward: Dictionary = REWARDS[idx]
	match reward["type"]:
		"cds":
			GameManager.add_cds(reward["amount"])
			return "Day %d reward: %s" % [day_index, reward["label"]]
		"boost":
			GameManager.activate_boost(2.0, reward["duration"])
			return "Day %d reward: %s" % [day_index, reward["label"]]
	return ""
