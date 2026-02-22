class_name GameConfig
extends RefCounted

## Global game tuning constants. All magic numbers live here.

## CD Spawning
const CD_SPAWN_INTERVAL := 1.2  # Seconds between CD spawns
const CD_LIFETIME := 4.0  # Seconds before a CD despawns if not tapped
const CD_MAX_ON_SCREEN := 12  # Maximum CDs visible at once
const CD_SPAWN_AREA_MARGIN := 60  # Pixels from screen edge

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
