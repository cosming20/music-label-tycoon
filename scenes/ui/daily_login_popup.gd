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
