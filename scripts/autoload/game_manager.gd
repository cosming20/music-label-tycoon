extends Node

## Core game state singleton. All player data lives here.
## UI scenes connect to signals to stay in sync.

# --- Signals ---
signal cds_changed(new_amount: float)
signal total_earned_changed(new_total: float)
signal artist_purchased(artist_tier: int, count: int)
signal artist_leveled_up(artist_tier: int, new_level: int)
signal upgrade_purchased(upgrade_id: int, new_level: int)
signal boost_activated(multiplier: float, duration: float)
signal game_loaded()

# --- Player State ---
var cds: float = 0.0
var total_cds_earned: float = 0.0

## {tier_id (int): owned_count (int)}
var artists_owned: Dictionary = {}

## {tier_id (int): level (int)}
var artist_levels: Dictionary = {}

## {upgrade_id (int): level (int)}
var studio_upgrades: Dictionary = {}

## Daily login tracking
var login_streak: int = 0
var last_login_day: int = -1  # Day of year

## Gacha pity counter
var gacha_pity_counter: int = 0

## Spin wheel last spin timestamp
var last_spin_time: float = 0.0

## Active boost
var _boost_multiplier: float = 1.0
var _boost_timer: float = 0.0

## Timestamp of last save (for offline calculation)
var last_save_timestamp: float = 0.0

func _ready() -> void:
	SaveManager.call_deferred("load_game")

func _process(delta: float) -> void:
	# Apply passive income from artists
	var income := get_total_production() * delta
	if income > 0:
		add_cds(income)

	# Tick boost timer
	if _boost_timer > 0:
		_boost_timer -= delta
		if _boost_timer <= 0:
			_boost_multiplier = 1.0
			_boost_timer = 0.0

# --- CD Management ---

func add_cds(amount: float) -> void:
	var boosted := amount * _boost_multiplier
	cds += boosted
	total_cds_earned += boosted
	cds_changed.emit(cds)
	total_earned_changed.emit(total_cds_earned)

func spend_cds(amount: float) -> bool:
	if cds >= amount:
		cds -= amount
		cds_changed.emit(cds)
		return true
	return false

func can_afford(amount: float) -> bool:
	return cds >= amount

# --- Artist Management ---

func get_artist_count(tier: int) -> int:
	return artists_owned.get(tier, 0)

func get_artist_level(tier: int) -> int:
	return artist_levels.get(tier, 0)

func is_artist_unlocked(tier: int) -> bool:
	var data: Dictionary = ArtistData.TIERS.get(tier, {})
	return total_cds_earned >= data.get("unlock_threshold", INF)

func buy_artist(tier: int) -> bool:
	if not is_artist_unlocked(tier):
		return false
	var count := get_artist_count(tier)
	var cost := ArtistData.purchase_cost(tier, count)
	if spend_cds(cost):
		artists_owned[tier] = count + 1
		if tier not in artist_levels:
			artist_levels[tier] = 0
		artist_purchased.emit(tier, count + 1)
		return true
	return false

func upgrade_artist(tier: int) -> bool:
	var current_level := get_artist_level(tier)
	if current_level >= ArtistData.MAX_LEVEL:
		return false
	if get_artist_count(tier) <= 0:
		return false
	var cost := ArtistData.upgrade_cost(tier, current_level)
	if spend_cds(cost):
		artist_levels[tier] = current_level + 1
		artist_leveled_up.emit(tier, current_level + 1)
		return true
	return false

## Total CD production per second from all artists.
func get_total_production() -> float:
	var total := 0.0
	for tier in artists_owned:
		var count: int = artists_owned[tier]
		var level: int = artist_levels.get(tier, 0)
		var per_artist := ArtistData.production_at_level(tier, level)
		total += per_artist * count
	# Apply studio Recording Quality bonus
	var quality_level: int = studio_upgrades.get(UpgradeData.UpgradeId.RECORDING_QUALITY, 0)
	var quality_bonus := 1.0 + (quality_level * UpgradeData.UPGRADES[UpgradeData.UpgradeId.RECORDING_QUALITY]["effect_per_level"])
	return total * quality_bonus

# --- Studio Upgrades ---

func get_upgrade_level(upgrade_id: int) -> int:
	return studio_upgrades.get(upgrade_id, 0)

func buy_upgrade(upgrade_id: int) -> bool:
	var current_level := get_upgrade_level(upgrade_id)
	var max_level: int = UpgradeData.UPGRADES[upgrade_id]["max_level"]
	if current_level >= max_level:
		return false
	var cost := UpgradeData.cost_at_level(upgrade_id, current_level)
	if spend_cds(cost):
		studio_upgrades[upgrade_id] = current_level + 1
		upgrade_purchased.emit(upgrade_id, current_level + 1)
		return true
	return false

# --- Boosts ---

func activate_boost(multiplier: float, duration: float) -> void:
	_boost_multiplier = multiplier
	_boost_timer = duration
	boost_activated.emit(multiplier, duration)

func get_current_boost() -> float:
	return _boost_multiplier

func get_boost_time_remaining() -> float:
	return _boost_timer

# --- Offline Earnings ---

func calculate_offline_earnings() -> float:
	if last_save_timestamp <= 0:
		return 0.0
	var now := Time.get_unix_time_from_system()
	var elapsed := now - last_save_timestamp
	var max_seconds := GameConfig.OFFLINE_EARNINGS_MAX_HOURS * 3600.0
	elapsed = min(elapsed, max_seconds)
	if elapsed < 60.0:  # Less than a minute, skip
		return 0.0
	var per_second := get_total_production() * GameConfig.OFFLINE_EARNINGS_RATE
	return per_second * elapsed

# --- Daily Login ---

func check_daily_login() -> Dictionary:
	var today := Time.get_date_dict_from_system()
	var day_of_year := today["day"] + today["month"] * 31  # Simple unique day ID
	if day_of_year == last_login_day:
		return {"is_new_day": false, "streak": login_streak}
	if day_of_year == last_login_day + 1 or last_login_day == -1:
		login_streak = min(login_streak + 1, GameConfig.LOGIN_STREAK_LENGTH)
	else:
		login_streak = 1  # Streak broken
	last_login_day = day_of_year
	return {"is_new_day": true, "streak": login_streak}

# --- Marketing Reach (affects CD drop weights) ---

func get_marketing_bonus() -> float:
	var level: int = studio_upgrades.get(UpgradeData.UpgradeId.MARKETING_REACH, 0)
	return level * UpgradeData.UPGRADES[UpgradeData.UpgradeId.MARKETING_REACH]["effect_per_level"]

# --- Serialization ---

func to_save_data() -> Dictionary:
	return {
		"cds": cds,
		"total_cds_earned": total_cds_earned,
		"artists_owned": artists_owned,
		"artist_levels": artist_levels,
		"studio_upgrades": studio_upgrades,
		"login_streak": login_streak,
		"last_login_day": last_login_day,
		"gacha_pity_counter": gacha_pity_counter,
		"last_spin_time": last_spin_time,
		"timestamp": Time.get_unix_time_from_system(),
	}

func load_save_data(data: Dictionary) -> void:
	cds = data.get("cds", 0.0)
	total_cds_earned = data.get("total_cds_earned", 0.0)
	artists_owned = data.get("artists_owned", {})
	artist_levels = data.get("artist_levels", {})
	studio_upgrades = data.get("studio_upgrades", {})
	login_streak = data.get("login_streak", 0)
	last_login_day = data.get("last_login_day", -1)
	gacha_pity_counter = data.get("gacha_pity_counter", 0)
	last_spin_time = data.get("last_spin_time", 0.0)
	last_save_timestamp = data.get("timestamp", 0.0)
	cds_changed.emit(cds)
	game_loaded.emit()
