extends Control

@onready var nav_bar: PanelContainer = %NavBar

func _ready() -> void:
	nav_bar.screen_requested.connect(func(s): SceneRouter.go_to(s))
