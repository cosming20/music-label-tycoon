extends Node

## Handles saving and loading game state to disk.

const SAVE_PATH := "user://save.json"
const AUTO_SAVE_INTERVAL := 30.0

var _auto_save_timer: float = 0.0

func _ready() -> void:
	print("SaveManager loaded")

func _process(delta: float) -> void:
	_auto_save_timer += delta
	if _auto_save_timer >= AUTO_SAVE_INTERVAL:
		_auto_save_timer = 0.0
		save_game()

func save_game() -> void:
	var save_data := {
		"cds": GameManager.cds,
		"total_cds_earned": GameManager.total_cds_earned,
		"artists_owned": GameManager.artists_owned,
		"artist_levels": GameManager.artist_levels,
		"studio_upgrades": GameManager.studio_upgrades,
		"timestamp": Time.get_unix_time_from_system(),
	}
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(save_data))

func load_game() -> bool:
	if not FileAccess.file_exists(SAVE_PATH):
		return false
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if not file:
		return false
	var json := JSON.new()
	var result := json.parse(file.get_as_text())
	if result != OK:
		return false
	var data: Dictionary = json.data
	GameManager.cds = data.get("cds", 0.0)
	GameManager.total_cds_earned = data.get("total_cds_earned", 0.0)
	GameManager.artists_owned = data.get("artists_owned", {})
	GameManager.artist_levels = data.get("artist_levels", {})
	GameManager.studio_upgrades = data.get("studio_upgrades", {})
	GameManager.last_save_timestamp = data.get("timestamp", 0.0)
	return true
