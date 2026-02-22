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
	SceneRouter.go_to(screen_name)
