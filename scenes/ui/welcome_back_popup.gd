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
