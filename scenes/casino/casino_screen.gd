extends Control

## Casino hub — shows available gambling games.

@onready var nav_bar: PanelContainer = %NavBar
@onready var game_container: VBoxContainer = %GameContainer

func _ready() -> void:
	nav_bar.screen_requested.connect(_on_screen_requested)
	_setup_games()

func _setup_games() -> void:
	# Spin Wheel — always available
	var spin_card := _make_game_card(
		"Daily Spin Wheel",
		"Spin for free prizes every 4 hours!",
		"res://assets/sprites/casino/spin_wheel_base.png",
		func(): SceneRouter.go_to("spin_wheel"),
		true
	)
	game_container.add_child(spin_card)

	# Gacha — unlock at 1K total CDs
	var gacha_unlocked := GameManager.total_cds_earned >= GameConfig.GACHA_UNLOCK
	var gacha_desc := "Open mystery crates for rare rewards!"
	if not gacha_unlocked:
		gacha_desc = "Locked: Earn %s total CDs" % GameConfig.format_number(GameConfig.GACHA_UNLOCK)
	var gacha_card := _make_game_card(
		"Mystery Crate",
		gacha_desc,
		"res://assets/sprites/ui/mystery_crate_closed.png",
		func(): SceneRouter.go_to("gacha"),
		gacha_unlocked
	)
	game_container.add_child(gacha_card)

func _make_game_card(title: String, desc: String, icon_path: String, on_press: Callable, enabled: bool) -> PanelContainer:
	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(0, 120)
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.08, 0.08, 0.15, 0.85)
	style.corner_radius_top_left = 12
	style.corner_radius_top_right = 12
	style.corner_radius_bottom_right = 12
	style.corner_radius_bottom_left = 12
	style.border_width_left = 1
	style.border_width_top = 1
	style.border_width_right = 1
	style.border_width_bottom = 1
	style.border_color = Color(0.7, 0.5, 0.1, 0.6)
	style.content_margin_left = 12.0
	style.content_margin_right = 12.0
	style.content_margin_top = 10.0
	style.content_margin_bottom = 10.0
	panel.add_theme_stylebox_override("panel", style)

	var hbox := HBoxContainer.new()
	hbox.add_theme_constant_override("separation", 16)
	panel.add_child(hbox)

	# Icon
	var icon := TextureRect.new()
	icon.custom_minimum_size = Vector2(80, 80)
	icon.expand_mode = 1
	icon.stretch_mode = 5
	var tex = load(icon_path)
	if tex:
		icon.texture = tex
	hbox.add_child(icon)

	# Info column
	var vbox := VBoxContainer.new()
	vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hbox.add_child(vbox)

	var title_lbl := Label.new()
	title_lbl.text = title
	title_lbl.add_theme_font_size_override("font_size", 20)
	title_lbl.add_theme_color_override("font_color", Color(1, 0.92, 0.4, 1))
	title_lbl.add_theme_color_override("font_outline_color", Color(0, 0, 0, 1))
	title_lbl.add_theme_constant_override("outline_size", 2)
	vbox.add_child(title_lbl)

	var desc_lbl := Label.new()
	desc_lbl.text = desc
	desc_lbl.add_theme_font_size_override("font_size", 13)
	desc_lbl.add_theme_color_override("font_color", Color(0.7, 0.8, 0.9, 0.9))
	desc_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD
	vbox.add_child(desc_lbl)

	var play_btn := Button.new()
	play_btn.text = "PLAY" if enabled else "LOCKED"
	play_btn.disabled = not enabled
	play_btn.custom_minimum_size = Vector2(0, 40)
	play_btn.pressed.connect(on_press)
	if not enabled:
		panel.modulate = Color(0.6, 0.6, 0.6, 0.8)
	vbox.add_child(play_btn)

	return panel

func _on_screen_requested(screen_name: String) -> void:
	SceneRouter.go_to(screen_name)
