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
