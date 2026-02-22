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
