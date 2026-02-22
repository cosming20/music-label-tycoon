# Music Label Tycoon - MVP Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Build a playable Android idle/tycoon game where players tap CDs, sign artists for passive income, upgrade their studio, and gamble — all in pixel art 2D using Godot 4.3+.

**Architecture:** Scene-per-screen with autoload singletons (GameManager, SaveManager, AudioManager) for shared state. GDScript throughout. Data-driven design: game constants defined in Resource files, logic in systems scripts, presentation in scenes.

**Tech Stack:** Godot 4.3+, GDScript, GUT (Godot Unit Test) for logic testing, AdMob plugin for Android ads, JSON for save data.

---

## Prerequisites

Before starting, ensure:
- Godot 4.3+ installed (download from https://godotengine.org)
- Android export templates installed in Godot (Editor > Manage Export Templates)
- Android SDK installed (for eventual device testing)
- GUT addon downloaded (https://github.com/bitwes/Gut)

---

## Task 1: Project Scaffolding

**Goal:** Create the Godot project with the full directory structure and verify it opens cleanly.

**Files:**
- Create: `project.godot`
- Create: All directory structure (empty dirs with `.gdkeep` files)
- Create: `scripts/autoload/game_manager.gd` (minimal stub)

**Step 1: Create directory structure**

```bash
cd /Users/cosmingagea/workspace/tycoon

# Create all directories
mkdir -p assets/sprites/{cds,artists,ui,effects}
mkdir -p assets/audio/{music,sfx}
mkdir -p assets/fonts
mkdir -p scenes/{main,artists,studio,casino,shop}
mkdir -p scenes/ui
mkdir -p scripts/autoload
mkdir -p scripts/data
mkdir -p scripts/systems/gambling
mkdir -p addons
mkdir -p tests

# Add .gdkeep to empty dirs so git tracks them
find assets scenes scripts addons tests -type d -empty -exec touch {}/.gdkeep \;
```

**Step 2: Create project.godot**

Create the Godot project file manually. This is the root config that makes the folder a Godot project.

```ini
; Engine configuration file.
; It's best edited using the editor UI and not directly,
; but it can also be edited via text for setup.

[application]

config/name="Music Label Tycoon"
config/description="A music label idle tycoon game"
run/main_scene="res://scenes/main/main_screen.tscn"
config/features=PackedStringArray("4.3", "Mobile")

[autoload]

GameManager="*res://scripts/autoload/game_manager.gd"
SaveManager="*res://scripts/autoload/save_manager.gd"
AudioManager="*res://scripts/autoload/audio_manager.gd"

[display]

window/size/viewport_width=540
window/size/viewport_height=960
window/stretch/mode="canvas_items"
window/stretch/aspect="keep_width"
window/handheld/orientation=1

[input_devices]

pointing/emulate_touch_from_mouse=true

[rendering]

renderer/rendering_method="mobile"
textures/canvas_textures/default_texture_filter=0
```

**Step 3: Create minimal autoload stubs**

Create `scripts/autoload/game_manager.gd`:
```gdscript
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
```

Create `scripts/autoload/save_manager.gd`:
```gdscript
extends Node

## Handles saving and loading game state to disk.

const SAVE_PATH := "user://save.json"
const AUTO_SAVE_INTERVAL := 30.0

var _auto_save_timer: float = 0.0

func _ready() -> void:
	print("SaveManager loaded")

func _process(delta: float) -> void:
	_auto_save_timer += delta
	if _auto_save_timer >= AUTO_SAVE_INTERVAL:
		_auto_save_timer = 0.0
		save_game()

func save_game() -> void:
	var save_data := {
		"cds": GameManager.cds,
		"total_cds_earned": GameManager.total_cds_earned,
		"artists_owned": GameManager.artists_owned,
		"artist_levels": GameManager.artist_levels,
		"studio_upgrades": GameManager.studio_upgrades,
		"timestamp": Time.get_unix_time_from_system(),
	}
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(save_data))

func load_game() -> bool:
	if not FileAccess.file_exists(SAVE_PATH):
		return false
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if not file:
		return false
	var json := JSON.new()
	var result := json.parse(file.get_as_text())
	if result != OK:
		return false
	var data: Dictionary = json.data
	GameManager.cds = data.get("cds", 0.0)
	GameManager.total_cds_earned = data.get("total_cds_earned", 0.0)
	GameManager.artists_owned = data.get("artists_owned", {})
	GameManager.artist_levels = data.get("artist_levels", {})
	GameManager.studio_upgrades = data.get("studio_upgrades", {})
	GameManager.last_save_timestamp = data.get("timestamp", 0.0)
	return true
```

Create `scripts/autoload/audio_manager.gd`:
```gdscript
extends Node

## Controls background music and sound effects across scenes.

func _ready() -> void:
	print("AudioManager loaded")
```

**Step 4: Create a minimal main scene so the project can run**

Create `scenes/main/main_screen.tscn` (minimal placeholder):
```
[gd_scene format=3 uid="uid://placeholder_main"]

[node name="MainScreen" type="Control"]
layout_mode = 3
anchors_preset = 15
anchor_right = 1.0
anchor_bottom = 1.0
grow_horizontal = 2
grow_vertical = 2
```

**Step 5: Verify project opens in Godot**

Run: Open Godot, import the project at `/Users/cosmingagea/workspace/tycoon/`, verify it loads without errors.

**Step 6: Commit**

```bash
git add -A
git commit -m "feat: scaffold Godot project with directory structure and autoload stubs"
```

---

## Task 2: Game Data Layer

**Goal:** Define all game constants (CD tiers, artist tiers, upgrade definitions) as GDScript Resource classes so they're data-driven and easy to tune.

**Files:**
- Create: `scripts/data/cd_data.gd`
- Create: `scripts/data/artist_data.gd`
- Create: `scripts/data/upgrade_data.gd`
- Create: `scripts/data/game_config.gd`

**Step 1: Create CD tier data**

Create `scripts/data/cd_data.gd`:
```gdscript
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
```

**Step 2: Create artist tier data**

Create `scripts/data/artist_data.gd`:
```gdscript
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
```

**Step 3: Create upgrade data**

Create `scripts/data/upgrade_data.gd`:
```gdscript
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
```

**Step 4: Create game config (global tuning constants)**

Create `scripts/data/game_config.gd`:
```gdscript
class_name GameConfig
extends RefCounted

## Global game tuning constants. All magic numbers live here.

## CD Spawning
const CD_SPAWN_INTERVAL := 1.2  # Seconds between CD spawns
const CD_LIFETIME := 4.0  # Seconds before a CD despawns if not tapped
const CD_MAX_ON_SCREEN := 12  # Maximum CDs visible at once
const CD_SPAWN_AREA_MARGIN := 40  # Pixels from screen edge

## Idle / Offline
const OFFLINE_EARNINGS_MAX_HOURS := 8.0  # Cap offline earnings at 8 hours
const OFFLINE_EARNINGS_RATE := 0.5  # 50% of online rate while offline

## Gambling Unlock Thresholds (total CDs earned)
const SPIN_WHEEL_UNLOCK := 0.0  # Available immediately
const GACHA_UNLOCK := 1000.0
const SLOTS_UNLOCK := 10000.0
const CARD_FLIP_UNLOCK := 50000.0
const SCRATCH_CARD_UNLOCK := 100000.0

## Spin Wheel
const SPIN_WHEEL_COOLDOWN := 14400.0  # 4 hours in seconds

## Gacha
const GACHA_SINGLE_COST := 500.0
const GACHA_TEN_PULL_COST := 4500.0
const GACHA_PITY_RARE := 30
const GACHA_PITY_LEGENDARY := 100

## Daily Login
const LOGIN_STREAK_LENGTH := 7

## Ad Rewards
const AD_BOOST_DURATION := 30.0  # Seconds of 2x boost after ad
const AD_BOOST_MULTIPLIER := 2.0

## Number formatting thresholds
const NUMBER_FORMAT_THRESHOLDS: Array = [
	{"threshold": 1_000_000_000, "suffix": "B"},
	{"threshold": 1_000_000, "suffix": "M"},
	{"threshold": 1_000, "suffix": "K"},
]

## Format a large number for display (e.g., 1234567 -> "1.23M").
static func format_number(value: float) -> String:
	for entry in NUMBER_FORMAT_THRESHOLDS:
		if value >= entry["threshold"]:
			return "%.2f%s" % [value / entry["threshold"], entry["suffix"]]
	return str(int(value))
```

**Step 5: Commit**

```bash
git add scripts/data/
git commit -m "feat: add game data layer (CD tiers, artist tiers, upgrades, config)"
```

---

## Task 3: GameManager — Full State Management

**Goal:** Flesh out GameManager with complete player state, passive income calculation, and signal-driven updates.

**Files:**
- Modify: `scripts/autoload/game_manager.gd`

**Step 1: Implement full GameManager**

Replace `scripts/autoload/game_manager.gd` with:
```gdscript
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
```

**Step 2: Update SaveManager to use serialization helpers**

Replace `scripts/autoload/save_manager.gd` with:
```gdscript
extends Node

## Handles saving and loading game state to disk.

const SAVE_PATH := "user://save.json"
const AUTO_SAVE_INTERVAL := 30.0

var _auto_save_timer: float = 0.0

func _ready() -> void:
	# Save when app goes to background (Android)
	get_tree().auto_accept_quit = false

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_GO_BACK_REQUEST:
		save_game()
		get_tree().quit()
	elif what == NOTIFICATION_APPLICATION_FOCUS_OUT:
		save_game()

func _process(delta: float) -> void:
	_auto_save_timer += delta
	if _auto_save_timer >= AUTO_SAVE_INTERVAL:
		_auto_save_timer = 0.0
		save_game()

func save_game() -> void:
	var save_data := GameManager.to_save_data()
	var json_string := JSON.stringify(save_data, "\t")
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(json_string)

func load_game() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		return
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if not file:
		return
	var json := JSON.new()
	var result := json.parse(file.get_as_text())
	if result != OK:
		push_warning("SaveManager: Failed to parse save file")
		return
	var data: Dictionary = json.data
	GameManager.load_save_data(data)

	# Calculate and apply offline earnings
	var offline_cds := GameManager.calculate_offline_earnings()
	if offline_cds > 0:
		GameManager.add_cds(offline_cds)
		# TODO: Show "Welcome back" popup with offline earnings

func delete_save() -> void:
	if FileAccess.file_exists(SAVE_PATH):
		DirAccess.remove_absolute(SAVE_PATH)
```

**Step 3: Verify scripts parse without errors**

Run: Open Godot editor, check Output panel for errors. All three autoloads should print their "loaded" messages.

**Step 4: Commit**

```bash
git add scripts/autoload/ scripts/data/
git commit -m "feat: implement GameManager state, SaveManager persistence, and game data layer"
```

---

## Task 4: Main Screen — HUD and CD Tap Area

**Goal:** Build the main game screen with a top HUD showing CD count + production rate, a tap area where CDs spawn, and a bottom navigation bar.

**Files:**
- Create: `scenes/main/main_screen.tscn` (replace placeholder)
- Create: `scenes/main/main_screen.gd`
- Create: `scenes/ui/hud.tscn`
- Create: `scenes/ui/hud.gd`
- Create: `scenes/ui/nav_bar.tscn`
- Create: `scenes/ui/nav_bar.gd`

**Step 1: Create HUD scene**

Create `scenes/ui/hud.gd`:
```gdscript
extends PanelContainer

## Top HUD bar showing CD count, production rate, and boost status.

@onready var cd_count_label: Label = %CdCountLabel
@onready var production_label: Label = %ProductionLabel
@onready var boost_label: Label = %BoostLabel

func _ready() -> void:
	GameManager.cds_changed.connect(_on_cds_changed)
	_update_display()

func _process(_delta: float) -> void:
	# Update production rate display periodically
	var production := GameManager.get_total_production()
	production_label.text = "%s/sec" % GameConfig.format_number(production)

	# Update boost timer
	var boost_time := GameManager.get_boost_time_remaining()
	if boost_time > 0:
		boost_label.text = "%.0fx (%ds)" % [GameManager.get_current_boost(), int(boost_time)]
		boost_label.visible = true
	else:
		boost_label.visible = false

func _on_cds_changed(new_amount: float) -> void:
	_update_display()

func _update_display() -> void:
	cd_count_label.text = GameConfig.format_number(GameManager.cds)
```

Create `scenes/ui/hud.tscn`:
```
[gd_scene load_steps=2 format=3]

[ext_resource type="Script" path="res://scenes/ui/hud.gd" id="1"]

[node name="HUD" type="PanelContainer"]
offset_right = 540.0
offset_bottom = 80.0
script = ExtResource("1")

[node name="HBoxContainer" type="HBoxContainer" parent="."]
layout_mode = 2

[node name="VBoxContainer" type="VBoxContainer" parent="HBoxContainer"]
layout_mode = 2
size_flags_horizontal = 3

[node name="CdCountLabel" type="Label" parent="HBoxContainer/VBoxContainer"]
unique_name_in_owner = true
layout_mode = 2
text = "0"
horizontal_alignment = 1
vertical_alignment = 1

[node name="ProductionLabel" type="Label" parent="HBoxContainer/VBoxContainer"]
unique_name_in_owner = true
layout_mode = 2
text = "0/sec"
horizontal_alignment = 1
vertical_alignment = 1

[node name="BoostLabel" type="Label" parent="HBoxContainer"]
unique_name_in_owner = true
layout_mode = 2
text = "2x (30s)"
horizontal_alignment = 2
visible = false
```

**Step 2: Create bottom navigation bar**

Create `scenes/ui/nav_bar.gd`:
```gdscript
extends PanelContainer

## Bottom navigation bar for switching between game screens.

signal screen_requested(screen_name: String)

func _ready() -> void:
	for button: Button in %ButtonContainer.get_children():
		button.pressed.connect(_on_button_pressed.bind(button.name.to_lower()))

func _on_button_pressed(screen_name: String) -> void:
	screen_requested.emit(screen_name)
```

Create `scenes/ui/nav_bar.tscn`:
```
[gd_scene load_steps=2 format=3]

[ext_resource type="Script" path="res://scenes/ui/nav_bar.gd" id="1"]

[node name="NavBar" type="PanelContainer"]
anchors_preset = 12
anchor_top = 1.0
anchor_right = 1.0
anchor_bottom = 1.0
offset_top = -70.0
grow_horizontal = 2
grow_vertical = 0
script = ExtResource("1")

[node name="ButtonContainer" type="HBoxContainer" parent="."]
unique_name_in_owner = true
layout_mode = 2
alignment = 1

[node name="Main" type="Button" parent="ButtonContainer"]
layout_mode = 2
size_flags_horizontal = 3
text = "Label"

[node name="Artists" type="Button" parent="ButtonContainer"]
layout_mode = 2
size_flags_horizontal = 3
text = "Artists"

[node name="Studio" type="Button" parent="ButtonContainer"]
layout_mode = 2
size_flags_horizontal = 3
text = "Studio"

[node name="Casino" type="Button" parent="ButtonContainer"]
layout_mode = 2
size_flags_horizontal = 3
text = "Casino"

[node name="Shop" type="Button" parent="ButtonContainer"]
layout_mode = 2
size_flags_horizontal = 3
text = "Shop"
```

**Step 3: Build the main screen with CD tap area**

Create `scenes/main/main_screen.gd`:
```gdscript
extends Control

## Main game screen — CDs spawn in the tap area, player taps to collect.

@onready var tap_area: Control = %TapArea
@onready var hud: PanelContainer = %HUD
@onready var nav_bar: PanelContainer = %NavBar

var _spawn_timer: float = 0.0
var _cd_scene: PackedScene

func _ready() -> void:
	_cd_scene = preload("res://scenes/main/cd_pickup.tscn")
	nav_bar.screen_requested.connect(_on_screen_requested)

func _process(delta: float) -> void:
	_spawn_timer += delta
	if _spawn_timer >= GameConfig.CD_SPAWN_INTERVAL:
		_spawn_timer = 0.0
		_try_spawn_cd()

func _try_spawn_cd() -> void:
	# Count current CDs on screen
	var current_count := 0
	for child in tap_area.get_children():
		if child.is_in_group("cd_pickup"):
			current_count += 1
	if current_count >= GameConfig.CD_MAX_ON_SCREEN:
		return
	_spawn_cd()

func _spawn_cd() -> void:
	var cd := _cd_scene.instantiate()
	# Random position within tap area bounds
	var margin := GameConfig.CD_SPAWN_AREA_MARGIN
	var area_size := tap_area.size
	var x := randf_range(margin, area_size.x - margin)
	var y := randf_range(margin, area_size.y - margin)
	cd.position = Vector2(x, y)

	# Pick tier (affected by marketing upgrade)
	var tier := _pick_weighted_tier()
	cd.setup(tier)
	cd.collected.connect(_on_cd_collected)
	tap_area.add_child(cd)

func _pick_weighted_tier() -> int:
	var marketing_bonus := GameManager.get_marketing_bonus()
	# Marketing shifts weights: reduce common, increase rare
	var roll := randf() * CdData.total_drop_weight()
	var cumulative := 0.0
	var last_tier := CdData.CdTier.DEMO
	for tier_id in CdData.TIERS:
		var weight: float = CdData.TIERS[tier_id]["drop_weight"]
		# Marketing bonus reduces weight of low tiers, increases high tiers
		if tier_id <= CdData.CdTier.EP:
			weight *= max(0.1, 1.0 - marketing_bonus)
		else:
			weight *= (1.0 + marketing_bonus)
		cumulative += weight
		last_tier = tier_id
		if roll <= cumulative:
			return tier_id
	return last_tier

func _on_cd_collected(tier: int) -> void:
	var value: float = CdData.TIERS[tier]["value"]
	GameManager.add_cds(value)

func _on_screen_requested(screen_name: String) -> void:
	match screen_name:
		"artists":
			get_tree().change_scene_to_file("res://scenes/artists/artist_screen.tscn")
		"studio":
			get_tree().change_scene_to_file("res://scenes/studio/studio_screen.tscn")
		"casino":
			get_tree().change_scene_to_file("res://scenes/casino/casino_screen.tscn")
		"shop":
			get_tree().change_scene_to_file("res://scenes/shop/shop_screen.tscn")
		"main":
			pass  # Already here
```

**Step 4: Create the CD pickup scene (tappable CD)**

Create `scenes/main/cd_pickup.gd`:
```gdscript
extends Control

## A tappable CD that appears on the main screen.

signal collected(tier: int)

var _tier: int = CdData.CdTier.DEMO
var _lifetime: float = 0.0
var _bob_offset: float = 0.0

@onready var sprite: ColorRect = %Sprite
@onready var label: Label = %ValueLabel

func setup(tier: int) -> void:
	_tier = tier
	_bob_offset = randf() * TAU  # Random phase for bobbing animation

func _ready() -> void:
	add_to_group("cd_pickup")
	# Apply tier visuals
	var tier_data: Dictionary = CdData.TIERS[_tier]
	sprite.color = tier_data["color"]
	label.text = GameConfig.format_number(tier_data["value"])
	# Scale based on tier
	var base_scale := 0.8 + (_tier * 0.1)
	scale = Vector2(base_scale, base_scale)

func _process(delta: float) -> void:
	_lifetime += delta
	# Gentle bobbing animation
	position.y += sin(Time.get_ticks_msec() * 0.003 + _bob_offset) * 0.3
	# Despawn after lifetime
	if _lifetime >= GameConfig.CD_LIFETIME:
		_fade_and_remove()

func _gui_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch and event.pressed:
		collected.emit(_tier)
		_collect_animation()

func _collect_animation() -> void:
	# Quick scale-up + fade out
	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "scale", scale * 1.5, 0.15)
	tween.tween_property(self, "modulate:a", 0.0, 0.15)
	tween.chain().tween_callback(queue_free)

func _fade_and_remove() -> void:
	var tween := create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.5)
	tween.tween_callback(queue_free)
```

Create `scenes/main/cd_pickup.tscn`:
```
[gd_scene load_steps=2 format=3]

[ext_resource type="Script" path="res://scenes/main/cd_pickup.gd" id="1"]

[node name="CdPickup" type="Control"]
custom_minimum_size = Vector2(48, 48)
script = ExtResource("1")

[node name="Sprite" type="ColorRect" parent="."]
unique_name_in_owner = true
layout_mode = 0
offset_right = 48.0
offset_bottom = 48.0
color = Color(0.75, 0.75, 0.75, 1)
mouse_filter = 2

[node name="ValueLabel" type="Label" parent="."]
unique_name_in_owner = true
layout_mode = 0
offset_right = 48.0
offset_bottom = 48.0
horizontal_alignment = 1
vertical_alignment = 1
mouse_filter = 2
```

**Step 5: Assemble main_screen.tscn**

Replace `scenes/main/main_screen.tscn`:
```
[gd_scene load_steps=4 format=3]

[ext_resource type="Script" path="res://scenes/main/main_screen.gd" id="1"]
[ext_resource type="PackedScene" path="res://scenes/ui/hud.tscn" id="2"]
[ext_resource type="PackedScene" path="res://scenes/ui/nav_bar.tscn" id="3"]

[node name="MainScreen" type="Control"]
layout_mode = 3
anchors_preset = 15
anchor_right = 1.0
anchor_bottom = 1.0
grow_horizontal = 2
grow_vertical = 2
script = ExtResource("1")

[node name="Background" type="ColorRect" parent="."]
layout_mode = 1
anchors_preset = 15
anchor_right = 1.0
anchor_bottom = 1.0
color = Color(0.12, 0.12, 0.18, 1)

[node name="HUD" type="PanelContainer" parent="." instance=ExtResource("2")]
unique_name_in_owner = true
layout_mode = 1
anchors_preset = 10
anchor_right = 1.0
offset_bottom = 80.0
grow_horizontal = 2

[node name="TapArea" type="Control" parent="."]
unique_name_in_owner = true
layout_mode = 1
anchors_preset = 15
anchor_right = 1.0
anchor_bottom = 1.0
offset_top = 80.0
offset_bottom = -70.0
grow_horizontal = 2
grow_vertical = 2

[node name="NavBar" type="PanelContainer" parent="." instance=ExtResource("3")]
unique_name_in_owner = true
layout_mode = 1
```

**Step 6: Run and verify CDs spawn and can be tapped**

Run: Press F5 in Godot. CDs should appear in the tap area. Clicking/tapping them should increase the CD counter in the HUD.

**Step 7: Commit**

```bash
git add scenes/ scripts/
git commit -m "feat: main screen with HUD, CD spawning, tap collection, and nav bar"
```

---

## Task 5: Artist Roster Screen

**Goal:** Build the artist management screen where players can buy and upgrade artists.

**Files:**
- Create: `scenes/artists/artist_screen.tscn`
- Create: `scenes/artists/artist_screen.gd`
- Create: `scenes/artists/artist_card.tscn`
- Create: `scenes/artists/artist_card.gd`

**Step 1: Create artist card component**

Create `scenes/artists/artist_card.gd`:
```gdscript
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
@onready var icon_rect: ColorRect = %IconRect
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
	icon_rect.color = data["color"]

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
```

Create `scenes/artists/artist_card.tscn`:
```
[gd_scene load_steps=2 format=3]

[ext_resource type="Script" path="res://scenes/artists/artist_card.gd" id="1"]

[node name="ArtistCard" type="PanelContainer"]
custom_minimum_size = Vector2(0, 120)
script = ExtResource("1")

[node name="HBox" type="HBoxContainer" parent="."]
layout_mode = 2

[node name="IconRect" type="ColorRect" parent="HBox"]
unique_name_in_owner = true
layout_mode = 2
custom_minimum_size = Vector2(64, 64)
color = Color(0.6, 0.4, 0.2, 1)

[node name="Info" type="VBoxContainer" parent="HBox"]
layout_mode = 2
size_flags_horizontal = 3

[node name="NameLabel" type="Label" parent="HBox/Info"]
unique_name_in_owner = true
layout_mode = 2
text = "Artist Name"

[node name="CountLabel" type="Label" parent="HBox/Info"]
unique_name_in_owner = true
layout_mode = 2
text = "Owned: 0"

[node name="LevelLabel" type="Label" parent="HBox/Info"]
unique_name_in_owner = true
layout_mode = 2
text = "Lv. 0"

[node name="ProductionLabel" type="Label" parent="HBox/Info"]
unique_name_in_owner = true
layout_mode = 2
text = "0/sec"

[node name="Buttons" type="VBoxContainer" parent="HBox"]
layout_mode = 2

[node name="BuyButton" type="Button" parent="HBox/Buttons"]
unique_name_in_owner = true
layout_mode = 2
text = "Sign (50)"

[node name="UpgradeButton" type="Button" parent="HBox/Buttons"]
unique_name_in_owner = true
layout_mode = 2
text = "Level Up (25)"

[node name="LockOverlay" type="ColorRect" parent="."]
unique_name_in_owner = true
layout_mode = 2
color = Color(0, 0, 0, 0.6)
mouse_filter = 2
visible = false
```

**Step 2: Create artist screen**

Create `scenes/artists/artist_screen.gd`:
```gdscript
extends Control

## Artist roster screen — lists all artist tiers with buy/upgrade controls.

@onready var scroll: ScrollContainer = %ScrollContainer
@onready var artist_list: VBoxContainer = %ArtistList
@onready var nav_bar: PanelContainer = %NavBar

var _card_scene: PackedScene

func _ready() -> void:
	_card_scene = preload("res://scenes/artists/artist_card.tscn")
	nav_bar.screen_requested.connect(_on_screen_requested)
	_build_artist_list()

func _build_artist_list() -> void:
	# MVP: only first 3 tiers
	var mvp_tiers := [
		ArtistData.ArtistTier.BUSKER,
		ArtistData.ArtistTier.GARAGE_BAND,
		ArtistData.ArtistTier.INDIE_ARTIST,
	]
	for tier in mvp_tiers:
		var card := _card_scene.instantiate()
		card.setup(tier)
		card.buy_pressed.connect(_on_buy_artist)
		card.upgrade_pressed.connect(_on_upgrade_artist)
		artist_list.add_child(card)

func _on_buy_artist(tier: int) -> void:
	GameManager.buy_artist(tier)

func _on_upgrade_artist(tier: int) -> void:
	GameManager.upgrade_artist(tier)

func _on_screen_requested(screen_name: String) -> void:
	match screen_name:
		"main":
			get_tree().change_scene_to_file("res://scenes/main/main_screen.tscn")
		"studio":
			get_tree().change_scene_to_file("res://scenes/studio/studio_screen.tscn")
		"casino":
			get_tree().change_scene_to_file("res://scenes/casino/casino_screen.tscn")
		"shop":
			get_tree().change_scene_to_file("res://scenes/shop/shop_screen.tscn")
```

Create `scenes/artists/artist_screen.tscn`:
```
[gd_scene load_steps=3 format=3]

[ext_resource type="Script" path="res://scenes/artists/artist_screen.gd" id="1"]
[ext_resource type="PackedScene" path="res://scenes/ui/nav_bar.tscn" id="2"]

[node name="ArtistScreen" type="Control"]
layout_mode = 3
anchors_preset = 15
anchor_right = 1.0
anchor_bottom = 1.0
grow_horizontal = 2
grow_vertical = 2
script = ExtResource("1")

[node name="Background" type="ColorRect" parent="."]
layout_mode = 1
anchors_preset = 15
anchor_right = 1.0
anchor_bottom = 1.0
color = Color(0.1, 0.12, 0.2, 1)

[node name="Title" type="Label" parent="."]
layout_mode = 1
anchors_preset = 10
anchor_right = 1.0
offset_bottom = 50.0
text = "Artist Roster"
horizontal_alignment = 1
vertical_alignment = 1

[node name="ScrollContainer" type="ScrollContainer" parent="."]
unique_name_in_owner = true
layout_mode = 1
anchors_preset = 15
anchor_right = 1.0
anchor_bottom = 1.0
offset_top = 50.0
offset_bottom = -70.0

[node name="ArtistList" type="VBoxContainer" parent="ScrollContainer"]
unique_name_in_owner = true
layout_mode = 2
size_flags_horizontal = 3

[node name="NavBar" type="PanelContainer" parent="." instance=ExtResource("2")]
unique_name_in_owner = true
layout_mode = 1
```

**Step 3: Verify navigation and artist buying works**

Run: F5 → tap "Artists" in nav bar → see artist cards → buy a Busker → verify CD count decreases and artist shows "Owned: 1" → go back to main screen → verify passive income appears in HUD.

**Step 4: Commit**

```bash
git add scenes/artists/
git commit -m "feat: artist roster screen with buy and upgrade functionality"
```

---

## Task 6: Studio Upgrade Screen

**Goal:** Build the studio upgrades screen.

**Files:**
- Create: `scenes/studio/studio_screen.tscn`
- Create: `scenes/studio/studio_screen.gd`
- Create: `scenes/studio/upgrade_card.tscn`
- Create: `scenes/studio/upgrade_card.gd`

**Step 1: Create upgrade card**

Create `scenes/studio/upgrade_card.gd`:
```gdscript
extends PanelContainer

## A single studio upgrade card.

signal purchase_pressed(upgrade_id: int)

var _upgrade_id: int

@onready var name_label: Label = %NameLabel
@onready var desc_label: Label = %DescLabel
@onready var level_label: Label = %LevelLabel
@onready var buy_button: Button = %BuyButton
@onready var icon_rect: ColorRect = %IconRect

func setup(upgrade_id: int) -> void:
	_upgrade_id = upgrade_id

func _ready() -> void:
	GameManager.cds_changed.connect(func(_v): _update_display())
	GameManager.upgrade_purchased.connect(func(_id, _lv): _update_display())
	buy_button.pressed.connect(func(): purchase_pressed.emit(_upgrade_id))
	_update_display()

func _update_display() -> void:
	var data: Dictionary = UpgradeData.UPGRADES[_upgrade_id]
	var level := GameManager.get_upgrade_level(_upgrade_id)
	var max_level: int = data["max_level"]

	name_label.text = data["name"]
	desc_label.text = data["description"]
	icon_rect.color = data["icon_color"]

	if level >= max_level:
		level_label.text = "MAX (Lv. %d)" % level
		buy_button.disabled = true
		buy_button.text = "Maxed"
	else:
		level_label.text = "Level %d / %d" % [level, max_level]
		var cost := UpgradeData.cost_at_level(_upgrade_id, level)
		buy_button.text = "Upgrade (%s)" % GameConfig.format_number(cost)
		buy_button.disabled = not GameManager.can_afford(cost)
```

Create `scenes/studio/upgrade_card.tscn`:
```
[gd_scene load_steps=2 format=3]

[ext_resource type="Script" path="res://scenes/studio/upgrade_card.gd" id="1"]

[node name="UpgradeCard" type="PanelContainer"]
custom_minimum_size = Vector2(0, 100)
script = ExtResource("1")

[node name="HBox" type="HBoxContainer" parent="."]
layout_mode = 2

[node name="IconRect" type="ColorRect" parent="HBox"]
unique_name_in_owner = true
layout_mode = 2
custom_minimum_size = Vector2(64, 64)

[node name="Info" type="VBoxContainer" parent="HBox"]
layout_mode = 2
size_flags_horizontal = 3

[node name="NameLabel" type="Label" parent="HBox/Info"]
unique_name_in_owner = true
layout_mode = 2
text = "Upgrade Name"

[node name="DescLabel" type="Label" parent="HBox/Info"]
unique_name_in_owner = true
layout_mode = 2
text = "Description"

[node name="LevelLabel" type="Label" parent="HBox/Info"]
unique_name_in_owner = true
layout_mode = 2
text = "Level 0 / 50"

[node name="BuyButton" type="Button" parent="HBox"]
unique_name_in_owner = true
layout_mode = 2
text = "Upgrade (100)"
```

**Step 2: Create studio screen**

Create `scenes/studio/studio_screen.gd`:
```gdscript
extends Control

## Studio upgrades screen.

@onready var upgrade_list: VBoxContainer = %UpgradeList
@onready var nav_bar: PanelContainer = %NavBar

var _card_scene: PackedScene

func _ready() -> void:
	_card_scene = preload("res://scenes/studio/upgrade_card.tscn")
	nav_bar.screen_requested.connect(_on_screen_requested)
	_build_upgrade_list()

func _build_upgrade_list() -> void:
	for upgrade_id in UpgradeData.UPGRADES:
		var card := _card_scene.instantiate()
		card.setup(upgrade_id)
		card.purchase_pressed.connect(_on_upgrade_purchased)
		upgrade_list.add_child(card)

func _on_upgrade_purchased(upgrade_id: int) -> void:
	GameManager.buy_upgrade(upgrade_id)

func _on_screen_requested(screen_name: String) -> void:
	match screen_name:
		"main":
			get_tree().change_scene_to_file("res://scenes/main/main_screen.tscn")
		"artists":
			get_tree().change_scene_to_file("res://scenes/artists/artist_screen.tscn")
		"casino":
			get_tree().change_scene_to_file("res://scenes/casino/casino_screen.tscn")
		"shop":
			get_tree().change_scene_to_file("res://scenes/shop/shop_screen.tscn")
```

Create `scenes/studio/studio_screen.tscn`:
```
[gd_scene load_steps=3 format=3]

[ext_resource type="Script" path="res://scenes/studio/studio_screen.gd" id="1"]
[ext_resource type="PackedScene" path="res://scenes/ui/nav_bar.tscn" id="2"]

[node name="StudioScreen" type="Control"]
layout_mode = 3
anchors_preset = 15
anchor_right = 1.0
anchor_bottom = 1.0
grow_horizontal = 2
grow_vertical = 2
script = ExtResource("1")

[node name="Background" type="ColorRect" parent="."]
layout_mode = 1
anchors_preset = 15
anchor_right = 1.0
anchor_bottom = 1.0
color = Color(0.15, 0.1, 0.1, 1)

[node name="Title" type="Label" parent="."]
layout_mode = 1
anchors_preset = 10
anchor_right = 1.0
offset_bottom = 50.0
text = "Recording Studio"
horizontal_alignment = 1
vertical_alignment = 1

[node name="ScrollContainer" type="ScrollContainer" parent="."]
layout_mode = 1
anchors_preset = 15
anchor_right = 1.0
anchor_bottom = 1.0
offset_top = 50.0
offset_bottom = -70.0

[node name="UpgradeList" type="VBoxContainer" parent="ScrollContainer"]
unique_name_in_owner = true
layout_mode = 2
size_flags_horizontal = 3

[node name="NavBar" type="PanelContainer" parent="." instance=ExtResource("2")]
unique_name_in_owner = true
layout_mode = 1
```

**Step 3: Verify upgrades work**

Run: Navigate to Studio screen → buy Recording Quality → go back to main → verify production rate increased.

**Step 4: Commit**

```bash
git add scenes/studio/
git commit -m "feat: studio upgrade screen with recording quality and marketing reach"
```

---

## Task 7: Daily Spin Wheel

**Goal:** Build the first gambling feature — a spin wheel with weighted prizes.

**Files:**
- Create: `scenes/casino/casino_screen.tscn`
- Create: `scenes/casino/casino_screen.gd`
- Create: `scenes/casino/spin_wheel.tscn`
- Create: `scenes/casino/spin_wheel.gd`
- Create: `scripts/systems/gambling/spin_wheel_data.gd`

**Step 1: Define spin wheel prizes**

Create `scripts/systems/gambling/spin_wheel_data.gd`:
```gdscript
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
```

**Step 2: Create the spin wheel scene**

Create `scenes/casino/spin_wheel.gd`:
```gdscript
extends Control

## Animated spin wheel with weighted prize selection.

signal spin_complete(prize: Dictionary)

@onready var wheel_container: Control = %WheelContainer
@onready var spin_button: Button = %SpinButton
@onready var result_label: Label = %ResultLabel
@onready var cooldown_label: Label = %CooldownLabel

var _is_spinning := false
var _current_rotation := 0.0
var _target_rotation := 0.0
var _spin_speed := 0.0

func _ready() -> void:
	spin_button.pressed.connect(_on_spin_pressed)
	_update_cooldown_display()
	_draw_wheel()

func _process(delta: float) -> void:
	if _is_spinning:
		_current_rotation += _spin_speed * delta
		_spin_speed *= 0.98  # Decelerate
		wheel_container.rotation = _current_rotation
		if _spin_speed < 0.05:
			_is_spinning = false
			_on_spin_finished()
	_update_cooldown_display()

func _draw_wheel() -> void:
	# Placeholder: colored segments drawn as child ColorRects
	var segment_count := SpinWheelData.PRIZES.size()
	for i in segment_count:
		var segment := ColorRect.new()
		segment.size = Vector2(40, 100)
		segment.position = Vector2(120 + cos(i * TAU / segment_count) * 80 - 20,
								   120 + sin(i * TAU / segment_count) * 80 - 50)
		segment.color = SpinWheelData.PRIZES[i]["color"]
		var lbl := Label.new()
		lbl.text = SpinWheelData.PRIZES[i]["label"]
		lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		lbl.size = segment.size
		segment.add_child(lbl)
		wheel_container.add_child(segment)

func can_spin() -> bool:
	var now := Time.get_unix_time_from_system()
	return (now - GameManager.last_spin_time) >= GameConfig.SPIN_WHEEL_COOLDOWN

func _on_spin_pressed() -> void:
	if _is_spinning:
		return
	if not can_spin():
		return
	GameManager.last_spin_time = Time.get_unix_time_from_system()
	_is_spinning = true
	_spin_speed = randf_range(15.0, 25.0)
	result_label.text = ""
	spin_button.disabled = true

func _on_spin_finished() -> void:
	var prize := SpinWheelData.pick_prize()
	var message := SpinWheelData.apply_prize(prize)
	result_label.text = message
	spin_button.disabled = false
	spin_complete.emit(prize)

func _update_cooldown_display() -> void:
	if can_spin():
		cooldown_label.text = "Free spin available!"
		spin_button.disabled = _is_spinning
	else:
		var remaining := GameConfig.SPIN_WHEEL_COOLDOWN - (Time.get_unix_time_from_system() - GameManager.last_spin_time)
		var hours := int(remaining / 3600)
		var minutes := int(fmod(remaining, 3600) / 60)
		cooldown_label.text = "Next free spin: %dh %dm" % [hours, minutes]
		spin_button.disabled = true
```

Create `scenes/casino/spin_wheel.tscn`:
```
[gd_scene load_steps=2 format=3]

[ext_resource type="Script" path="res://scenes/casino/spin_wheel.gd" id="1"]

[node name="SpinWheel" type="Control"]
custom_minimum_size = Vector2(300, 400)
script = ExtResource("1")

[node name="WheelContainer" type="Control" parent="."]
unique_name_in_owner = true
layout_mode = 0
position = Vector2(30, 20)
size = Vector2(240, 240)

[node name="SpinButton" type="Button" parent="."]
unique_name_in_owner = true
layout_mode = 0
offset_left = 80.0
offset_top = 280.0
offset_right = 220.0
offset_bottom = 320.0
text = "SPIN!"

[node name="ResultLabel" type="Label" parent="."]
unique_name_in_owner = true
layout_mode = 0
offset_top = 330.0
offset_right = 300.0
offset_bottom = 370.0
horizontal_alignment = 1

[node name="CooldownLabel" type="Label" parent="."]
unique_name_in_owner = true
layout_mode = 0
offset_top = 370.0
offset_right = 300.0
offset_bottom = 400.0
horizontal_alignment = 1
```

**Step 3: Create casino hub screen**

Create `scenes/casino/casino_screen.gd`:
```gdscript
extends Control

## Casino hub — shows available gambling games.

@onready var nav_bar: PanelContainer = %NavBar
@onready var game_container: VBoxContainer = %GameContainer

func _ready() -> void:
	nav_bar.screen_requested.connect(_on_screen_requested)
	_setup_games()

func _setup_games() -> void:
	# Spin Wheel — always available
	var spin_wheel_btn := Button.new()
	spin_wheel_btn.text = "Daily Spin Wheel"
	spin_wheel_btn.pressed.connect(func():
		get_tree().change_scene_to_file("res://scenes/casino/spin_wheel_screen.tscn"))
	game_container.add_child(spin_wheel_btn)

	# Gacha — unlock at 1K total CDs
	var gacha_btn := Button.new()
	gacha_btn.text = "Mystery Crate"
	if GameManager.total_cds_earned < GameConfig.GACHA_UNLOCK:
		gacha_btn.text += " (Locked: %s CDs needed)" % GameConfig.format_number(GameConfig.GACHA_UNLOCK)
		gacha_btn.disabled = true
	gacha_btn.pressed.connect(func():
		get_tree().change_scene_to_file("res://scenes/casino/gacha_screen.tscn"))
	game_container.add_child(gacha_btn)

func _on_screen_requested(screen_name: String) -> void:
	match screen_name:
		"main":
			get_tree().change_scene_to_file("res://scenes/main/main_screen.tscn")
		"artists":
			get_tree().change_scene_to_file("res://scenes/artists/artist_screen.tscn")
		"studio":
			get_tree().change_scene_to_file("res://scenes/studio/studio_screen.tscn")
		"shop":
			get_tree().change_scene_to_file("res://scenes/shop/shop_screen.tscn")
```

Create `scenes/casino/casino_screen.tscn`:
```
[gd_scene load_steps=3 format=3]

[ext_resource type="Script" path="res://scenes/casino/casino_screen.gd" id="1"]
[ext_resource type="PackedScene" path="res://scenes/ui/nav_bar.tscn" id="2"]

[node name="CasinoScreen" type="Control"]
layout_mode = 3
anchors_preset = 15
anchor_right = 1.0
anchor_bottom = 1.0
grow_horizontal = 2
grow_vertical = 2
script = ExtResource("1")

[node name="Background" type="ColorRect" parent="."]
layout_mode = 1
anchors_preset = 15
anchor_right = 1.0
anchor_bottom = 1.0
color = Color(0.08, 0.15, 0.08, 1)

[node name="Title" type="Label" parent="."]
layout_mode = 1
anchors_preset = 10
anchor_right = 1.0
offset_bottom = 50.0
text = "Casino"
horizontal_alignment = 1
vertical_alignment = 1

[node name="GameContainer" type="VBoxContainer" parent="."]
unique_name_in_owner = true
layout_mode = 1
anchors_preset = 15
anchor_right = 1.0
anchor_bottom = 1.0
offset_top = 60.0
offset_bottom = -70.0
offset_left = 20.0
offset_right = -20.0

[node name="NavBar" type="PanelContainer" parent="." instance=ExtResource("2")]
unique_name_in_owner = true
layout_mode = 1
```

**Step 4: Create spin wheel wrapper screen (with back button)**

Create `scenes/casino/spin_wheel_screen.gd`:
```gdscript
extends Control

@onready var nav_bar: PanelContainer = %NavBar

func _ready() -> void:
	nav_bar.screen_requested.connect(func(s):
		if s == "casino":
			get_tree().change_scene_to_file("res://scenes/casino/casino_screen.tscn")
		else:
			get_tree().change_scene_to_file("res://scenes/main/main_screen.tscn"))
```

Create `scenes/casino/spin_wheel_screen.tscn`:
```
[gd_scene load_steps=4 format=3]

[ext_resource type="Script" path="res://scenes/casino/spin_wheel_screen.gd" id="1"]
[ext_resource type="PackedScene" path="res://scenes/casino/spin_wheel.tscn" id="2"]
[ext_resource type="PackedScene" path="res://scenes/ui/nav_bar.tscn" id="3"]

[node name="SpinWheelScreen" type="Control"]
layout_mode = 3
anchors_preset = 15
anchor_right = 1.0
anchor_bottom = 1.0
grow_horizontal = 2
grow_vertical = 2
script = ExtResource("1")

[node name="Background" type="ColorRect" parent="."]
layout_mode = 1
anchors_preset = 15
anchor_right = 1.0
anchor_bottom = 1.0
color = Color(0.05, 0.1, 0.05, 1)

[node name="Title" type="Label" parent="."]
layout_mode = 1
anchors_preset = 10
anchor_right = 1.0
offset_bottom = 50.0
text = "Daily Spin Wheel"
horizontal_alignment = 1
vertical_alignment = 1

[node name="SpinWheel" type="Control" parent="." instance=ExtResource("2")]
layout_mode = 1
anchors_preset = 8
anchor_left = 0.5
anchor_top = 0.5
anchor_right = 0.5
anchor_bottom = 0.5
offset_left = -150.0
offset_top = -200.0
offset_right = 150.0
offset_bottom = 200.0

[node name="NavBar" type="PanelContainer" parent="." instance=ExtResource("3")]
unique_name_in_owner = true
layout_mode = 1
```

**Step 5: Verify spin wheel works**

Run: Navigate Casino → Spin Wheel → tap SPIN → wheel animates → prize awarded → cooldown shows.

**Step 6: Commit**

```bash
git add scenes/casino/ scripts/systems/gambling/
git commit -m "feat: casino hub with daily spin wheel gambling game"
```

---

## Task 8: Gacha / Mystery Crate System

**Goal:** Build the gacha pull system with pity counter.

**Files:**
- Create: `scripts/systems/gambling/gacha_data.gd`
- Create: `scenes/casino/gacha_screen.tscn`
- Create: `scenes/casino/gacha_screen.gd`

**Step 1: Define gacha prize pool**

Create `scripts/systems/gambling/gacha_data.gd`:
```gdscript
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
```

**Step 2: Create gacha screen**

Create `scenes/casino/gacha_screen.gd`:
```gdscript
extends Control

## Gacha pull screen with single and 10-pull options.

@onready var nav_bar: PanelContainer = %NavBar
@onready var single_pull_btn: Button = %SinglePullBtn
@onready var ten_pull_btn: Button = %TenPullBtn
@onready var result_container: VBoxContainer = %ResultContainer
@onready var pity_label: Label = %PityLabel

func _ready() -> void:
	nav_bar.screen_requested.connect(_on_screen_requested)
	single_pull_btn.pressed.connect(_on_single_pull)
	ten_pull_btn.pressed.connect(_on_ten_pull)
	_update_display()

func _update_display() -> void:
	single_pull_btn.text = "Pull x1 (%s CDs)" % GameConfig.format_number(GameConfig.GACHA_SINGLE_COST)
	ten_pull_btn.text = "Pull x10 (%s CDs)" % GameConfig.format_number(GameConfig.GACHA_TEN_PULL_COST)
	single_pull_btn.disabled = not GameManager.can_afford(GameConfig.GACHA_SINGLE_COST)
	ten_pull_btn.disabled = not GameManager.can_afford(GameConfig.GACHA_TEN_PULL_COST)
	pity_label.text = "Pity counter: %d (Rare at %d, Legendary at %d)" % [
		GameManager.gacha_pity_counter,
		GameConfig.GACHA_PITY_RARE,
		GameConfig.GACHA_PITY_LEGENDARY
	]

func _clear_results() -> void:
	for child in result_container.get_children():
		child.queue_free()

func _show_result(prize: Dictionary, message: String) -> void:
	var lbl := Label.new()
	var rarity_name: String = GachaData.RARITY_NAMES[prize["rarity"]]
	lbl.text = "[%s] %s — %s" % [rarity_name, prize["name"], message]
	lbl.add_theme_color_override("font_color", GachaData.RARITY_COLORS[prize["rarity"]])
	result_container.add_child(lbl)

func _on_single_pull() -> void:
	if not GameManager.spend_cds(GameConfig.GACHA_SINGLE_COST):
		return
	_clear_results()
	var prize := GachaData.pull()
	var msg := GachaData.apply_prize(prize)
	_show_result(prize, msg)
	_update_display()

func _on_ten_pull() -> void:
	if not GameManager.spend_cds(GameConfig.GACHA_TEN_PULL_COST):
		return
	_clear_results()
	for i in 10:
		var prize := GachaData.pull()
		var msg := GachaData.apply_prize(prize)
		_show_result(prize, msg)
	_update_display()

func _on_screen_requested(screen_name: String) -> void:
	get_tree().change_scene_to_file("res://scenes/casino/casino_screen.tscn")
```

Create `scenes/casino/gacha_screen.tscn`:
```
[gd_scene load_steps=3 format=3]

[ext_resource type="Script" path="res://scenes/casino/gacha_screen.gd" id="1"]
[ext_resource type="PackedScene" path="res://scenes/ui/nav_bar.tscn" id="2"]

[node name="GachaScreen" type="Control"]
layout_mode = 3
anchors_preset = 15
anchor_right = 1.0
anchor_bottom = 1.0
grow_horizontal = 2
grow_vertical = 2
script = ExtResource("1")

[node name="Background" type="ColorRect" parent="."]
layout_mode = 1
anchors_preset = 15
anchor_right = 1.0
anchor_bottom = 1.0
color = Color(0.1, 0.05, 0.15, 1)

[node name="Title" type="Label" parent="."]
layout_mode = 1
anchors_preset = 10
anchor_right = 1.0
offset_bottom = 50.0
text = "Mystery Crate"
horizontal_alignment = 1

[node name="PityLabel" type="Label" parent="."]
unique_name_in_owner = true
layout_mode = 1
anchors_preset = 10
anchor_right = 1.0
offset_top = 50.0
offset_bottom = 80.0
horizontal_alignment = 1

[node name="Buttons" type="HBoxContainer" parent="."]
layout_mode = 1
offset_top = 90.0
offset_right = 540.0
offset_bottom = 140.0
alignment = 1

[node name="SinglePullBtn" type="Button" parent="Buttons"]
unique_name_in_owner = true
layout_mode = 2
text = "Pull x1 (500)"

[node name="TenPullBtn" type="Button" parent="Buttons"]
unique_name_in_owner = true
layout_mode = 2
text = "Pull x10 (4500)"

[node name="ScrollContainer" type="ScrollContainer" parent="."]
layout_mode = 1
offset_top = 150.0
offset_right = 540.0
offset_bottom = -70.0

[node name="ResultContainer" type="VBoxContainer" parent="ScrollContainer"]
unique_name_in_owner = true
layout_mode = 2
size_flags_horizontal = 3

[node name="NavBar" type="PanelContainer" parent="." instance=ExtResource("2")]
unique_name_in_owner = true
layout_mode = 1
```

**Step 3: Verify gacha works**

Run: Casino → Mystery Crate → pull single/10-pull → verify CDs deducted, prizes shown with rarity colors, pity counter increments.

**Step 4: Commit**

```bash
git add scenes/casino/ scripts/systems/gambling/
git commit -m "feat: gacha mystery crate system with pity counter and rarity tiers"
```

---

## Task 9: Daily Login Rewards

**Goal:** Show a daily login popup with streak rewards when the player opens the game on a new day.

**Files:**
- Create: `scenes/ui/daily_login_popup.tscn`
- Create: `scenes/ui/daily_login_popup.gd`
- Create: `scripts/data/daily_rewards_data.gd`
- Modify: `scenes/main/main_screen.gd` (trigger popup on load)

**Step 1: Define daily rewards**

Create `scripts/data/daily_rewards_data.gd`:
```gdscript
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
```

**Step 2: Create daily login popup**

Create `scenes/ui/daily_login_popup.gd`:
```gdscript
extends PanelContainer

## Daily login reward popup shown on new day.

signal closed()

@onready var streak_label: Label = %StreakLabel
@onready var reward_label: Label = %RewardLabel
@onready var claim_button: Button = %ClaimButton
@onready var day_container: HBoxContainer = %DayContainer

var _streak: int = 0

func setup(streak: int) -> void:
	_streak = streak

func _ready() -> void:
	claim_button.pressed.connect(_on_claim)
	_display_streak()

func _display_streak() -> void:
	streak_label.text = "Day %d Streak!" % _streak
	# Show day indicators
	for i in GameConfig.LOGIN_STREAK_LENGTH:
		var day_label := Label.new()
		day_label.text = "Day %d" % (i + 1)
		if i < _streak:
			day_label.add_theme_color_override("font_color", Color.GOLD)
		else:
			day_label.add_theme_color_override("font_color", Color.DIM_GRAY)
		day_container.add_child(day_label)
	# Show today's reward
	var msg := DailyRewardsData.apply_reward(_streak)
	reward_label.text = msg

func _on_claim() -> void:
	closed.emit()
	queue_free()
```

Create `scenes/ui/daily_login_popup.tscn`:
```
[gd_scene load_steps=2 format=3]

[ext_resource type="Script" path="res://scenes/ui/daily_login_popup.gd" id="1"]

[node name="DailyLoginPopup" type="PanelContainer"]
anchors_preset = 8
anchor_left = 0.5
anchor_top = 0.5
anchor_right = 0.5
anchor_bottom = 0.5
offset_left = -200.0
offset_top = -150.0
offset_right = 200.0
offset_bottom = 150.0
script = ExtResource("1")

[node name="VBox" type="VBoxContainer" parent="."]
layout_mode = 2
alignment = 1

[node name="StreakLabel" type="Label" parent="VBox"]
unique_name_in_owner = true
layout_mode = 2
text = "Day 1 Streak!"
horizontal_alignment = 1

[node name="DayContainer" type="HBoxContainer" parent="VBox"]
unique_name_in_owner = true
layout_mode = 2
alignment = 1

[node name="RewardLabel" type="Label" parent="VBox"]
unique_name_in_owner = true
layout_mode = 2
text = "Reward: 100 CDs"
horizontal_alignment = 1

[node name="ClaimButton" type="Button" parent="VBox"]
unique_name_in_owner = true
layout_mode = 2
text = "Claim!"
```

**Step 3: Trigger daily login from main screen**

Add to `scenes/main/main_screen.gd` `_ready()`:
```gdscript
# At the end of _ready():
var daily_popup_scene := preload("res://scenes/ui/daily_login_popup.tscn")
# Check daily login after a short delay (let save load first)
await get_tree().create_timer(0.5).timeout
var login_result := GameManager.check_daily_login()
if login_result["is_new_day"]:
	var popup := daily_popup_scene.instantiate()
	popup.setup(login_result["streak"])
	add_child(popup)
```

**Step 4: Verify daily login works**

Run: Launch game → daily popup appears → claim reward → CD count increases. Delete save file and relaunch to test again.

**Step 5: Commit**

```bash
git add scenes/ui/daily_login_popup.* scripts/data/daily_rewards_data.gd scenes/main/main_screen.gd
git commit -m "feat: daily login streak rewards with popup and 7-day cycle"
```

---

## Task 10: Shop Screen (Placeholder + Ad Reward Button)

**Goal:** Build a minimal shop screen with a "Watch Ad for 2x Boost" button. Real AdMob integration comes in Task 11, but we wire up the button and reward logic now.

**Files:**
- Create: `scenes/shop/shop_screen.tscn`
- Create: `scenes/shop/shop_screen.gd`

**Step 1: Create shop screen**

Create `scenes/shop/shop_screen.gd`:
```gdscript
extends Control

## Shop screen — ad rewards and future IAP.

@onready var nav_bar: PanelContainer = %NavBar
@onready var boost_button: Button = %BoostButton
@onready var status_label: Label = %StatusLabel

func _ready() -> void:
	nav_bar.screen_requested.connect(_on_screen_requested)
	boost_button.pressed.connect(_on_boost_pressed)
	_update_display()

func _process(_delta: float) -> void:
	_update_display()

func _update_display() -> void:
	var remaining := GameManager.get_boost_time_remaining()
	if remaining > 0:
		status_label.text = "2x Boost active: %ds remaining" % int(remaining)
		boost_button.disabled = true
	else:
		status_label.text = "No active boosts"
		boost_button.disabled = false

func _on_boost_pressed() -> void:
	# TODO: Replace with actual AdMob rewarded ad call
	# For now, simulate watching an ad
	GameManager.activate_boost(GameConfig.AD_BOOST_MULTIPLIER, GameConfig.AD_BOOST_DURATION)
	status_label.text = "Boost activated!"

func _on_screen_requested(screen_name: String) -> void:
	match screen_name:
		"main":
			get_tree().change_scene_to_file("res://scenes/main/main_screen.tscn")
		"artists":
			get_tree().change_scene_to_file("res://scenes/artists/artist_screen.tscn")
		"studio":
			get_tree().change_scene_to_file("res://scenes/studio/studio_screen.tscn")
		"casino":
			get_tree().change_scene_to_file("res://scenes/casino/casino_screen.tscn")
```

Create `scenes/shop/shop_screen.tscn`:
```
[gd_scene load_steps=3 format=3]

[ext_resource type="Script" path="res://scenes/shop/shop_screen.gd" id="1"]
[ext_resource type="PackedScene" path="res://scenes/ui/nav_bar.tscn" id="2"]

[node name="ShopScreen" type="Control"]
layout_mode = 3
anchors_preset = 15
anchor_right = 1.0
anchor_bottom = 1.0
grow_horizontal = 2
grow_vertical = 2
script = ExtResource("1")

[node name="Background" type="ColorRect" parent="."]
layout_mode = 1
anchors_preset = 15
anchor_right = 1.0
anchor_bottom = 1.0
color = Color(0.15, 0.12, 0.05, 1)

[node name="Title" type="Label" parent="."]
layout_mode = 1
anchors_preset = 10
anchor_right = 1.0
offset_bottom = 50.0
text = "Shop"
horizontal_alignment = 1

[node name="VBox" type="VBoxContainer" parent="."]
layout_mode = 1
offset_top = 60.0
offset_right = 540.0
offset_bottom = -70.0
offset_left = 20.0
alignment = 1

[node name="StatusLabel" type="Label" parent="VBox"]
unique_name_in_owner = true
layout_mode = 2
text = "No active boosts"
horizontal_alignment = 1

[node name="BoostButton" type="Button" parent="VBox"]
unique_name_in_owner = true
layout_mode = 2
custom_minimum_size = Vector2(0, 60)
text = "Watch Ad for 2x Boost (30s)"

[node name="ComingSoon" type="Label" parent="VBox"]
layout_mode = 2
text = "More items coming soon..."
horizontal_alignment = 1

[node name="NavBar" type="PanelContainer" parent="." instance=ExtResource("2")]
unique_name_in_owner = true
layout_mode = 1
```

**Step 2: Verify shop and boost work**

Run: Navigate to Shop → tap boost button → verify boost appears in HUD → go back to main and verify production is doubled.

**Step 3: Commit**

```bash
git add scenes/shop/
git commit -m "feat: shop screen with simulated ad reward boost button"
```

---

## Task 11: Navigation System Refactor

**Goal:** Centralize navigation to avoid duplicating match statements in every screen. Create a SceneRouter utility.

**Files:**
- Create: `scripts/autoload/scene_router.gd`
- Modify: `project.godot` (add autoload)
- Modify: All screen scripts to use SceneRouter

**Step 1: Create scene router**

Create `scripts/autoload/scene_router.gd`:
```gdscript
extends Node

## Centralized scene navigation. All screen paths in one place.

const SCENES: Dictionary = {
	"main": "res://scenes/main/main_screen.tscn",
	"artists": "res://scenes/artists/artist_screen.tscn",
	"studio": "res://scenes/studio/studio_screen.tscn",
	"casino": "res://scenes/casino/casino_screen.tscn",
	"shop": "res://scenes/shop/shop_screen.tscn",
	"spin_wheel": "res://scenes/casino/spin_wheel_screen.tscn",
	"gacha": "res://scenes/casino/gacha_screen.tscn",
}

func go_to(screen_name: String) -> void:
	var path: String = SCENES.get(screen_name, SCENES["main"])
	get_tree().change_scene_to_file(path)
```

**Step 2: Register autoload in project.godot**

Add to `[autoload]` section:
```ini
SceneRouter="*res://scripts/autoload/scene_router.gd"
```

**Step 3: Update all screen scripts**

Replace all `_on_screen_requested` match blocks with:
```gdscript
func _on_screen_requested(screen_name: String) -> void:
	SceneRouter.go_to(screen_name)
```

**Step 4: Commit**

```bash
git add scripts/autoload/scene_router.gd project.godot scenes/
git commit -m "refactor: centralize navigation with SceneRouter autoload"
```

---

## Task 12: Offline Earnings "Welcome Back" Popup

**Goal:** When the player returns after being away, show accumulated offline earnings and let them claim (or double via ad).

**Files:**
- Create: `scenes/ui/welcome_back_popup.tscn`
- Create: `scenes/ui/welcome_back_popup.gd`
- Modify: `scenes/main/main_screen.gd` (show popup on load)

**Step 1: Create welcome back popup**

Create `scenes/ui/welcome_back_popup.gd`:
```gdscript
extends PanelContainer

## Shows offline earnings when player returns.

signal claimed(doubled: bool)

var _offline_cds: float = 0.0

@onready var earnings_label: Label = %EarningsLabel
@onready var claim_button: Button = %ClaimButton
@onready var double_button: Button = %DoubleButton

func setup(offline_cds: float) -> void:
	_offline_cds = offline_cds

func _ready() -> void:
	earnings_label.text = "While you were away, your artists earned:\n%s CDs!" % GameConfig.format_number(_offline_cds)
	claim_button.pressed.connect(_on_claim)
	double_button.pressed.connect(_on_double)

func _on_claim() -> void:
	# Earnings already added by SaveManager.load_game
	claimed.emit(false)
	queue_free()

func _on_double() -> void:
	# TODO: Replace with actual ad, then double
	GameManager.add_cds(_offline_cds)  # Add another round = double
	claimed.emit(true)
	queue_free()
```

Create `scenes/ui/welcome_back_popup.tscn`:
```
[gd_scene load_steps=2 format=3]

[ext_resource type="Script" path="res://scenes/ui/welcome_back_popup.gd" id="1"]

[node name="WelcomeBackPopup" type="PanelContainer"]
anchors_preset = 8
anchor_left = 0.5
anchor_top = 0.5
anchor_right = 0.5
anchor_bottom = 0.5
offset_left = -200.0
offset_top = -120.0
offset_right = 200.0
offset_bottom = 120.0
script = ExtResource("1")

[node name="VBox" type="VBoxContainer" parent="."]
layout_mode = 2
alignment = 1

[node name="EarningsLabel" type="Label" parent="VBox"]
unique_name_in_owner = true
layout_mode = 2
text = "While you were away..."
horizontal_alignment = 1
autowrap_mode = 2

[node name="HBox" type="HBoxContainer" parent="VBox"]
layout_mode = 2
alignment = 1

[node name="ClaimButton" type="Button" parent="VBox/HBox"]
unique_name_in_owner = true
layout_mode = 2
text = "Claim"

[node name="DoubleButton" type="Button" parent="VBox/HBox"]
unique_name_in_owner = true
layout_mode = 2
text = "Watch Ad for 2x"
```

**Step 2: Show welcome back popup in main screen**

Add to `scenes/main/main_screen.gd` `_ready()`, after daily login check:
```gdscript
# Show welcome back popup if there are offline earnings
var offline_cds := GameManager.calculate_offline_earnings()
if offline_cds > 100:  # Only show if meaningful amount
	var wb_scene := preload("res://scenes/ui/welcome_back_popup.tscn")
	var wb_popup := wb_scene.instantiate()
	wb_popup.setup(offline_cds)
	add_child(wb_popup)
```

Note: Move the offline earnings application from SaveManager to this popup (so it's only added when claimed). Update SaveManager to NOT auto-add offline earnings — just calculate the amount.

**Step 3: Commit**

```bash
git add scenes/ui/welcome_back_popup.* scenes/main/main_screen.gd scripts/autoload/save_manager.gd
git commit -m "feat: welcome back popup showing offline earnings with ad-double option"
```

---

## Task 13: AdMob Integration (Android)

**Goal:** Integrate the Godot AdMob plugin for rewarded ads on Android.

**Files:**
- Modify: `scripts/autoload/ad_manager.gd`
- Add: `addons/godot-admob/` (plugin files)
- Modify: `project.godot` (enable plugin)

**Step 1: Install godot-admob plugin**

Download from: https://github.com/poing-studios/godot-admob-android
Follow their installation instructions to add the plugin to `addons/`.

**Step 2: Implement AdManager**

Replace `scripts/autoload/ad_manager.gd`:
```gdscript
extends Node

## AdMob wrapper. Handles rewarded ads with fallback for desktop testing.

signal rewarded_ad_completed()
signal rewarded_ad_failed()

var _ad_loaded := false

func _ready() -> void:
	if _is_mobile():
		_init_admob()
	else:
		print("AdManager: Desktop mode — ads simulated")

func _is_mobile() -> bool:
	return OS.get_name() == "Android" or OS.get_name() == "iOS"

func _init_admob() -> void:
	# TODO: Initialize AdMob with your app ID
	# MobileAds.initialize()
	# Load first rewarded ad
	_load_rewarded_ad()
	pass

func _load_rewarded_ad() -> void:
	# TODO: Load rewarded ad via AdMob plugin
	# RewardedAd.load("ca-app-pub-XXXX/YYYY")
	_ad_loaded = true

func show_rewarded_ad() -> void:
	if _is_mobile() and _ad_loaded:
		# TODO: Show actual ad
		# RewardedAd.show()
		# Connect to reward callback
		_on_user_earned_reward()
	else:
		# Desktop: simulate watching ad (instant reward)
		_on_user_earned_reward()

func _on_user_earned_reward() -> void:
	_ad_loaded = false
	rewarded_ad_completed.emit()
	# Preload next ad
	_load_rewarded_ad()

func _on_ad_failed_to_load() -> void:
	_ad_loaded = false
	rewarded_ad_failed.emit()
```

**Step 3: Wire up ad manager to shop boost button**

Update shop screen to use AdManager:
```gdscript
func _on_boost_pressed() -> void:
	AdManager.rewarded_ad_completed.connect(_on_ad_reward, CONNECT_ONE_SHOT)
	AdManager.show_rewarded_ad()

func _on_ad_reward() -> void:
	GameManager.activate_boost(GameConfig.AD_BOOST_MULTIPLIER, GameConfig.AD_BOOST_DURATION)
```

**Step 4: Commit**

```bash
git add scripts/autoload/ad_manager.gd scenes/shop/
git commit -m "feat: AdMob integration with rewarded ad manager and desktop simulation"
```

---

## Task 14: Android Export Setup

**Goal:** Configure Android export and verify the game runs on a device/emulator.

**Step 1: Configure export preset**

In Godot: Project > Export > Add Preset > Android
- Package name: `com.yourstudio.musiclabeltycoon`
- Version: `1.0.0`
- Min SDK: 24
- Target SDK: 34
- Screen orientation: Portrait
- Permissions: INTERNET, ACCESS_NETWORK_STATE (for ads)

**Step 2: Generate debug keystore**

```bash
keytool -keyalg RSA -genkeypair -alias androiddebugkey -keypass android -keystore debug.keystore -storepass android -dname "CN=Android Debug,O=Android,C=US" -validity 9999 -deststoretype pkcs12
```

**Step 3: Configure Godot Android settings**

Editor > Editor Settings > Export > Android:
- Set Android SDK path
- Set debug keystore path

**Step 4: Export and test**

Project > Export > Android > Export Project (or Export PCK for testing)
Install on device: `adb install -r music_label_tycoon.apk`

**Step 5: Commit export config**

```bash
git add export_presets.cfg
git commit -m "feat: configure Android export with debug keystore and permissions"
```

---

## Summary — All Tasks

| # | Task | Scope | Est. Files |
|---|------|-------|-----------|
| 1 | Project Scaffolding | Godot project + dirs + autoload stubs | 5 |
| 2 | Game Data Layer | CD/Artist/Upgrade data classes + config | 4 |
| 3 | GameManager Full State | Complete state management + signals | 2 |
| 4 | Main Screen + HUD + CD Tapping | Core gameplay screen | 7 |
| 5 | Artist Roster Screen | Buy/upgrade artists | 4 |
| 6 | Studio Upgrade Screen | Global upgrades | 4 |
| 7 | Daily Spin Wheel | First gambling game | 5 |
| 8 | Gacha Mystery Crate | Second gambling game + pity | 3 |
| 9 | Daily Login Rewards | Streak popup + rewards | 3 |
| 10 | Shop Screen | Ad boost button | 2 |
| 11 | Navigation Refactor | SceneRouter autoload | 2+ |
| 12 | Offline Earnings Popup | Welcome back screen | 3 |
| 13 | AdMob Integration | Rewarded ads for Android | 2 |
| 14 | Android Export | Build config + keystore | 2 |

**Total: ~46 files for a playable MVP**

After completing all 14 tasks, you'll have a fully playable Music Label Tycoon on Android with:
- Tap-to-collect CDs (6 tiers)
- 3 artist tiers with passive income
- 2 studio upgrades
- Spin wheel + gacha gambling
- Daily login rewards
- Offline earnings
- Save/load persistence
- Rewarded ads
- Running on Android
