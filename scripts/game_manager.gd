extends Node
const SAVE_PATH := "user://progress.cfg"

var music_player := AudioStreamPlayer.new()

signal points_changed(points: int)
signal message_changed(text: String)
signal height_changed(height: int)
signal best_changed(best: int)


var restart_delay: float = 2.0
var win_delay: float = 3.0
var height: int = 0
var best_height: int = 0

var points: int = 0
var total_points: int = 0
var finished: bool = false
var _restarting: bool = false

func _ready() -> void:
	var cfg := ConfigFile.new()
	if cfg.load(SAVE_PATH) == OK:
		best_height = int(cfg.get_value("progress", "best_height", 0))


func start_level(total: int) -> void:
	if music_player.get_parent() == null:
		add_child(music_player)
		music_player.finished.connect(music_player.play)
	music_player.stream = load("res://assets/audio/music.wav")
	music_player.autoplay = true
	music_player.bus = "Music"
	music_player.play()
	
	points = 0
	height = 0
	total_points = total
	finished = false
	_restarting = false
	points_changed.emit(points)
	height_changed.emit(height)
	best_changed.emit(best_height)
	message_changed.emit("")

func on_collected(pts: int) -> void:
	points += pts
	points_changed.emit(points)

func report_height(h: int) -> void:
	if h == height:
		return
	height = h
	height_changed.emit(height)
	if height > best_height:
		best_height = height
		best_changed.emit(best_height)
		_save_best()


func player_died() -> void:
	if finished or _restarting:
		return
	_restarting = true
	message_changed.emit("YOU DIED\nPoints: %d" % points)
	await get_tree().create_timer(restart_delay).timeout
	get_tree().reload_current_scene()


func win() -> void:
	if finished or _restarting:
		return
	finished = true
	_restarting = true
	message_changed.emit("YOU WIN!")
	await get_tree().create_timer(win_delay).timeout
	get_tree().reload_current_scene()

# Saving height progress happens between rounds, sessions
func _save_best() -> void:
	var cfg := ConfigFile.new()
	cfg.set_value("progress", "best_height", best_height)
	cfg.save(SAVE_PATH)

# Reset best
func reset_best() -> void:
	best_height = 0
	best_changed.emit(best_height)
	_save_best()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_F9:
		reset_best()
		print("Best height reset")
