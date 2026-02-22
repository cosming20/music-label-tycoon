extends PanelContainer

## Bottom navigation bar for switching between game screens.

signal screen_requested(screen_name: String)

func _ready() -> void:
	for button: Button in %ButtonContainer.get_children():
		button.pressed.connect(_on_button_pressed.bind(button.name.to_lower()))

func _on_button_pressed(screen_name: String) -> void:
	screen_requested.emit(screen_name)
