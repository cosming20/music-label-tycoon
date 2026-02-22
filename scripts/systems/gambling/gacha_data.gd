class_name GachaData
extends RefCounted

## Gacha/mystery crate prize pool and pull logic with pity system.

enum Rarity {
	COMMON,
	UNCOMMON,
	RARE,
	LEGENDARY,
}

const POOL: Array = [
	{"rarity": Rarity.COMMON, "name": "50 CDs", "weight": 50, "action": "cds", "amount": 50},
	{"rarity": Rarity.COMMON, "name": "100 CDs", "weight": 30, "action": "cds", "amount": 100},
	{"rarity": Rarity.UNCOMMON, "name": "500 CDs", "weight": 12, "action": "cds", "amount": 500},
	{"rarity": Rarity.UNCOMMON, "name": "30s 2x Boost", "weight": 8, "action": "boost", "amount": 30},
	{"rarity": Rarity.RARE, "name": "2000 CDs", "weight": 4, "action": "cds", "amount": 2000},
	{"rarity": Rarity.RARE, "name": "60s 2x Boost", "weight": 3, "action": "boost", "amount": 60},
	{"rarity": Rarity.LEGENDARY, "name": "10000 CDs", "weight": 1, "action": "cds", "amount": 10000},
	{"rarity": Rarity.LEGENDARY, "name": "Free Artist", "weight": 0.5, "action": "artist", "amount": 1},
]

const RARITY_COLORS: Dictionary = {
	Rarity.COMMON: Color.GRAY,
	Rarity.UNCOMMON: Color.GREEN,
	Rarity.RARE: Color.DODGER_BLUE,
	Rarity.LEGENDARY: Color.GOLD,
}

const RARITY_NAMES: Dictionary = {
	Rarity.COMMON: "Common",
	Rarity.UNCOMMON: "Uncommon",
	Rarity.RARE: "Rare",
	Rarity.LEGENDARY: "Legendary",
}

## Pull a single prize, respecting pity system.
static func pull() -> Dictionary:
	GameManager.gacha_pity_counter += 1

	# Pity: force legendary at 100 pulls
	if GameManager.gacha_pity_counter >= GameConfig.GACHA_PITY_LEGENDARY:
		GameManager.gacha_pity_counter = 0
		return _pick_from_rarity(Rarity.LEGENDARY)

	# Pity: force rare at 30 pulls
	if GameManager.gacha_pity_counter >= GameConfig.GACHA_PITY_RARE:
		var prize := _weighted_pull()
		if prize["rarity"] >= Rarity.RARE:
			GameManager.gacha_pity_counter = 0
		return prize if prize["rarity"] >= Rarity.RARE else _pick_from_rarity(Rarity.RARE)

	var prize := _weighted_pull()
	if prize["rarity"] >= Rarity.RARE:
		GameManager.gacha_pity_counter = 0
	return prize

static func _weighted_pull() -> Dictionary:
	var total_weight := 0.0
	for item in POOL:
		total_weight += item["weight"]
	var roll := randf() * total_weight
	var cumulative := 0.0
	for item in POOL:
		cumulative += item["weight"]
		if roll <= cumulative:
			return item
	return POOL[0]

static func _pick_from_rarity(rarity: int) -> Dictionary:
	var candidates: Array = []
	for item in POOL:
		if item["rarity"] == rarity:
			candidates.append(item)
	if candidates.is_empty():
		return POOL[0]
	return candidates[randi() % candidates.size()]

## Apply the prize.
static func apply_prize(prize: Dictionary) -> String:
	match prize["action"]:
		"cds":
			GameManager.add_cds(prize["amount"])
			return "Won %s CDs!" % GameConfig.format_number(prize["amount"])
		"boost":
			GameManager.activate_boost(2.0, prize["amount"])
			return "2x Boost for %ds!" % prize["amount"]
		"artist":
			# Give the highest unlocked artist they don't have
			for tier in [ArtistData.ArtistTier.INDIE_ARTIST, ArtistData.ArtistTier.GARAGE_BAND, ArtistData.ArtistTier.BUSKER]:
				if GameManager.is_artist_unlocked(tier):
					GameManager.artists_owned[tier] = GameManager.get_artist_count(tier) + 1
					if tier not in GameManager.artist_levels:
						GameManager.artist_levels[tier] = 0
					var name: String = ArtistData.TIERS[tier]["name"]
					return "Got a free %s!" % name
			return "Won a free artist!"
	return ""
