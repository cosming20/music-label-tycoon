extends Node

## Centralized scene navigation. All screen paths in one place.

const SCENES: Dictionary = {
	"main": "res://scenes/main/main_screen.tscn",
	"artists": "res://scenes/artists/artist_screen.tscn",
	"studio": "res://scenes/studio/studio_screen.tscn",
	"casino": "res://scenes/casino/casino_screen.tscn",
	"shop": "res://scenes/shop/shop_screen.tscn",
	"spin_wheel": "res://scenes/casino/spin_wheel_screen.tscn",
	"gacha": "res://scenes/casino/gacha_screen.tscn",
}

func go_to(screen_name: String) -> void:
	var path: String = SCENES.get(screen_name, SCENES["main"])
	get_tree().change_scene_to_file(path)
