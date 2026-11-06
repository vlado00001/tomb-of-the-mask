extends Node2D

var points: float = 1

@onready var sparkle: AnimatedSprite2D = $Sparkle
@onready var sound: AudioStreamPlayer = $Sound
@onready var label: Label = $PointsLabel


func _ready() -> void:
	label.text = "+%d" % points
	sparkle.animation_finished.connect(sparkle.hide)
	sparkle.play("burst")
	sound.play()

	var tw := create_tween().set_parallel(true)
	tw.tween_property(label, "position:y", label.position.y - 14.0, 0.8)
	tw.tween_property(label, "modulate:a", 0.0, 0.8)

	await get_tree().create_timer(0.5).timeout
	queue_free()
