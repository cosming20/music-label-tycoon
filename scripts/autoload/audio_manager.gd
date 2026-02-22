extends Node

## Controls background music and sound effects across scenes.

var _bgm_player: AudioStreamPlayer
var _sfx_players: Array[AudioStreamPlayer] = []
const MAX_SFX_PLAYERS := 8

## Preloaded SFX
var _sfx_cache: Dictionary = {}

## BGM tracks
const BGM_TRACKS: Dictionary = {
	"main": "res://assets/audio/music/main_theme.wav",
	"casino": "res://assets/audio/music/casino_theme.wav",
}

## SFX paths
const SFX: Dictionary = {
	"collect_cd": "res://assets/audio/sfx/collect_cd.wav",
	"win_jingle": "res://assets/audio/sfx/win_jingle.wav",
	"spin_wheel": "res://assets/audio/sfx/spin_wheel.wav",
	"gacha_reveal": "res://assets/audio/sfx/gacha_reveal.wav",
}

var _current_bgm_key: String = ""

func _ready() -> void:
	# Create BGM player
	_bgm_player = AudioStreamPlayer.new()
	_bgm_player.bus = "Master"
	_bgm_player.volume_db = -6.0
	add_child(_bgm_player)

	# Create SFX player pool
	for i in MAX_SFX_PLAYERS:
		var player := AudioStreamPlayer.new()
		player.bus = "Master"
		add_child(player)
		_sfx_players.append(player)

	# Preload all SFX into cache
	for key in SFX:
		var stream = load(SFX[key])
		if stream:
			_sfx_cache[key] = stream

	# Start main theme after a short delay (let scene load)
	call_deferred("play_bgm", "main")

## Play a background music track by key. Loops automatically.
func play_bgm(track_key: String) -> void:
	if track_key == _current_bgm_key and _bgm_player.playing:
		return
	if track_key not in BGM_TRACKS:
		return
	var stream = load(BGM_TRACKS[track_key])
	if not stream:
		return
	_bgm_player.stream = stream
	_bgm_player.play()
	_current_bgm_key = track_key
	# Loop by reconnecting finished signal
	if not _bgm_player.finished.is_connected(_on_bgm_finished):
		_bgm_player.finished.connect(_on_bgm_finished)

func _on_bgm_finished() -> void:
	if _bgm_player.stream:
		_bgm_player.play()

## Stop background music.
func stop_bgm() -> void:
	_bgm_player.stop()
	_current_bgm_key = ""

## Play a sound effect by key.
func play_sfx(sfx_key: String) -> void:
	if sfx_key not in _sfx_cache:
		return
	# Find an available player from the pool
	for player in _sfx_players:
		if not player.playing:
			player.stream = _sfx_cache[sfx_key]
			player.play()
			return
	# All busy — use first player (interrupt oldest)
	_sfx_players[0].stream = _sfx_cache[sfx_key]
	_sfx_players[0].play()
