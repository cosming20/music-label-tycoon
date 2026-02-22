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

## Map screen names to their BGM track. Screens not listed use "main".
const SCREEN_BGM: Dictionary = {
	"casino": "casino",
	"spin_wheel": "casino",
	"gacha": "casino",
}

func go_to(screen_name: String) -> void:
	var path: String = SCENES.get(screen_name, SCENES["main"])
	# Switch BGM based on destination screen
	var bgm_key: String = SCREEN_BGM.get(screen_name, "main")
	AudioManager.play_bgm(bgm_key)
	get_tree().change_scene_to_file(path)
