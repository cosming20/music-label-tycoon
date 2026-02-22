extends Control

## Animated spin wheel with weighted prize selection.

signal spin_complete(prize: Dictionary)

@onready var wheel_container: Control = %WheelContainer
@onready var spin_button: Button = %SpinButton
@onready var result_label: Label = %ResultLabel
@onready var cooldown_label: Label = %CooldownLabel

var _is_spinning := false
var _current_rotation := 0.0
var _spin_speed := 0.0

func _ready() -> void:
	spin_button.pressed.connect(_on_spin_pressed)
	_update_cooldown_display()
	_build_wheel()

func _process(delta: float) -> void:
	if _is_spinning:
		_current_rotation += _spin_speed * delta
		_spin_speed *= 0.98
		wheel_container.rotation = _current_rotation
		if _spin_speed < 0.05:
			_is_spinning = false
			_on_spin_finished()
	_update_cooldown_display()

## Helper to create a TextureRect with explicit pixel bounds.
func _make_tex_rect(tex: Texture2D, x: float, y: float, w: float, h: float) -> TextureRect:
	var tr := TextureRect.new()
	tr.texture = tex
	tr.position = Vector2(x, y)
	tr.offset_right = w
	tr.offset_bottom = h
	tr.expand_mode = 1  # Ignore Size
	tr.stretch_mode = 5  # Keep Aspect Covered
	tr.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return tr

func _build_wheel() -> void:
	var ws := wheel_container.size  # 240x240 from .tscn
	var center := ws / 2.0
	wheel_container.clip_contents = true
	wheel_container.pivot_offset = center  # Rotate around center

	# Wheel base image — fills the entire container
	var base_tex = load("res://assets/sprites/casino/spin_wheel_base.png")
	if base_tex:
		var base := _make_tex_rect(base_tex, 0, 0, ws.x, ws.y)
		wheel_container.add_child(base)

	# Prize icons arranged in a circle
	var segment_count := SpinWheelData.PRIZES.size()
	var icon_sz := 36.0
	var radius := ws.x * 0.3

	for i in segment_count:
		var angle := (i * TAU / segment_count) - PI / 2.0
		var ix := center.x + cos(angle) * radius - icon_sz / 2.0
		var iy := center.y + sin(angle) * radius - icon_sz / 2.0

		# Prize icon
		var sprite_path: String = SpinWheelData.PRIZES[i].get("sprite", "")
		if sprite_path != "":
			var tex = load(sprite_path)
			if tex:
				var icon := _make_tex_rect(tex, ix, iy, icon_sz, icon_sz)
				wheel_container.add_child(icon)

		# Label
		var lbl := Label.new()
		lbl.text = SpinWheelData.PRIZES[i]["label"]
		lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		lbl.position = Vector2(ix - 10, iy + icon_sz)
		lbl.offset_right = icon_sz + 20
		lbl.offset_bottom = 16.0
		lbl.add_theme_font_size_override("font_size", 9)
		lbl.add_theme_color_override("font_color", Color.WHITE)
		lbl.add_theme_color_override("font_outline_color", Color.BLACK)
		lbl.add_theme_constant_override("outline_size", 3)
		lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE
		wheel_container.add_child(lbl)

	# Pointer arrow — NOT a child of wheel_container so it doesn't spin
	var pointer_tex = load("res://assets/sprites/casino/spin_wheel_pointer.png")
	if pointer_tex:
		# Position above the wheel center-top
		var ptr := _make_tex_rect(pointer_tex, wheel_container.position.x + center.x - 16, wheel_container.position.y - 24, 32, 32)
		add_child(ptr)

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
	AudioManager.play_sfx("spin_wheel")
	result_label.text = ""
	spin_button.disabled = true

func _on_spin_finished() -> void:
	var prize := SpinWheelData.pick_prize()
	var message := SpinWheelData.apply_prize(prize)
	result_label.text = message
	spin_button.disabled = false
	AudioManager.play_sfx("win_jingle")
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
