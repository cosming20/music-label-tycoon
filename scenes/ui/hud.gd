extends PanelContainer

## Top HUD bar showing CD count, production rate, and boost status.

@onready var cd_count_label: Label = %CdCountLabel
@onready var production_label: Label = %ProductionLabel
@onready var boost_label: Label = %BoostLabel

func _ready() -> void:
	GameManager.cds_changed.connect(_on_cds_changed)
	_update_display()

func _process(_delta: float) -> void:
	# Update production rate display periodically
	var production := GameManager.get_total_production()
	production_label.text = "%s/sec" % GameConfig.format_number(production)

	# Update boost timer
	var boost_time := GameManager.get_boost_time_remaining()
	if boost_time > 0:
		boost_label.text = "%.0fx (%ds)" % [GameManager.get_current_boost(), int(boost_time)]
		boost_label.visible = true
	else:
		boost_label.visible = false

func _on_cds_changed(new_amount: float) -> void:
	_update_display()

func _update_display() -> void:
	cd_count_label.text = GameConfig.format_number(GameManager.cds)
