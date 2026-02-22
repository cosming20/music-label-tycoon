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
