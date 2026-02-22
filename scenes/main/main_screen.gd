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
	_check_daily_login()

func _check_daily_login() -> void:
	var daily_popup_scene := preload("res://scenes/ui/daily_login_popup.tscn")
	# Check daily login after a short delay (let save load first)
	await get_tree().create_timer(0.5).timeout
	var login_result := GameManager.check_daily_login()
	if login_result["is_new_day"]:
		var popup := daily_popup_scene.instantiate()
		popup.setup(login_result["streak"])
		add_child(popup)

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
	SceneRouter.go_to(screen_name)
