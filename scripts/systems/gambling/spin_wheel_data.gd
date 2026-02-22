class_name SpinWheelData
extends RefCounted

## Spin wheel prize definitions and logic.

enum PrizeType {
	CDS_SMALL,
	CDS_MEDIUM,
	CDS_LARGE,
	BOOST_2X,
	PREMIUM_SMALL,
	NOTHING,
}

const PRIZES: Array = [
	{"type": PrizeType.CDS_SMALL, "label": "50 CDs", "weight": 30, "color": Color.DIM_GRAY},
	{"type": PrizeType.CDS_MEDIUM, "label": "200 CDs", "weight": 20, "color": Color.SILVER},
	{"type": PrizeType.CDS_LARGE, "label": "1000 CDs", "weight": 5, "color": Color.GOLD},
	{"type": PrizeType.BOOST_2X, "label": "2x Boost", "weight": 15, "color": Color.ORANGE},
	{"type": PrizeType.PREMIUM_SMALL, "label": "5 Gems", "weight": 5, "color": Color.MEDIUM_PURPLE},
	{"type": PrizeType.NOTHING, "label": "Try Again", "weight": 25, "color": Color.DARK_GRAY},
]

static func pick_prize() -> Dictionary:
	var total_weight := 0.0
	for prize in PRIZES:
		total_weight += prize["weight"]
	var roll := randf() * total_weight
	var cumulative := 0.0
	for prize in PRIZES:
		cumulative += prize["weight"]
		if roll <= cumulative:
			return prize
	return PRIZES[0]

## Apply the prize reward to the player.
static func apply_prize(prize: Dictionary) -> String:
	match prize["type"]:
		PrizeType.CDS_SMALL:
			GameManager.add_cds(50)
			return "You won 50 CDs!"
		PrizeType.CDS_MEDIUM:
			GameManager.add_cds(200)
			return "You won 200 CDs!"
		PrizeType.CDS_LARGE:
			GameManager.add_cds(1000)
			return "You won 1000 CDs!"
		PrizeType.BOOST_2X:
			GameManager.activate_boost(GameConfig.AD_BOOST_MULTIPLIER, GameConfig.AD_BOOST_DURATION)
			return "2x Boost activated for 30 seconds!"
		PrizeType.PREMIUM_SMALL:
			return "You won 5 Gems! (Coming soon)"
		PrizeType.NOTHING:
			return "Better luck next time!"
	return ""
