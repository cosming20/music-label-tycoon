extends PanelContainer

## A single studio upgrade card.

signal purchase_pressed(upgrade_id: int)

var _upgrade_id: int

@onready var name_label: Label = %NameLabel
@onready var desc_label: Label = %DescLabel
@onready var level_label: Label = %LevelLabel
@onready var buy_button: Button = %BuyButton
@onready var icon_rect: TextureRect = %IconRect

func setup(upgrade_id: int) -> void:
	_upgrade_id = upgrade_id

func _ready() -> void:
	GameManager.cds_changed.connect(func(_v): _update_display())
	GameManager.upgrade_purchased.connect(func(_id, _lv): _update_display())
	buy_button.pressed.connect(func(): purchase_pressed.emit(_upgrade_id))
	_update_display()

func _update_display() -> void:
	var data: Dictionary = UpgradeData.UPGRADES[_upgrade_id]
	var level := GameManager.get_upgrade_level(_upgrade_id)
	var max_level: int = data["max_level"]

	name_label.text = data["name"]
	desc_label.text = data["description"]
	var sprite_path: String = data.get("sprite", "")
	if sprite_path != "":
		icon_rect.texture = load(sprite_path)

	if level >= max_level:
		level_label.text = "MAX (Lv. %d)" % level
		buy_button.disabled = true
		buy_button.text = "Maxed"
	else:
		level_label.text = "Level %d / %d" % [level, max_level]
		var cost := UpgradeData.cost_at_level(_upgrade_id, level)
		buy_button.text = "Upgrade (%s)" % GameConfig.format_number(cost)
		buy_button.disabled = not GameManager.can_afford(cost)
