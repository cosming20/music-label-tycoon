extends Node

## Handles saving and loading game state to disk.

const SAVE_PATH := "user://save.json"
const AUTO_SAVE_INTERVAL := 30.0

var _auto_save_timer: float = 0.0

func _ready() -> void:
	# Save when app goes to background (Android)
	get_tree().auto_accept_quit = false

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_GO_BACK_REQUEST:
		save_game()
		get_tree().quit()
	elif what == NOTIFICATION_APPLICATION_FOCUS_OUT:
		save_game()

func _process(delta: float) -> void:
	_auto_save_timer += delta
	if _auto_save_timer >= AUTO_SAVE_INTERVAL:
		_auto_save_timer = 0.0
		save_game()

func save_game() -> void:
	var save_data := GameManager.to_save_data()
	var json_string := JSON.stringify(save_data, "\t")
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(json_string)

func load_game() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		return
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if not file:
		return
	var json := JSON.new()
	var result := json.parse(file.get_as_text())
	if result != OK:
		push_warning("SaveManager: Failed to parse save file")
		return
	var data: Dictionary = json.data
	GameManager.load_save_data(data)
	# Note: offline earnings are handled by the welcome back popup in main_screen.gd

func delete_save() -> void:
	if FileAccess.file_exists(SAVE_PATH):
		DirAccess.remove_absolute(SAVE_PATH)
