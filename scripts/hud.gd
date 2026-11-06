extends CanvasLayer

@onready var points_label: Label = $Margin/HBox/LeftBox/PointsLabel
@onready var height_label: Label = $Margin/HBox/RightBox/HeightLabel
@onready var best_label: Label = $Margin/HBox/RightBox/BestLabel
@onready var message_label: Label = $MessageLabel
@onready var gm = get_node("/root/GameManager")

func _ready() -> void:
	gm.points_changed.connect(_on_points_changed)
	gm.height_changed.connect(_on_height_changed)
	gm.best_changed.connect(_on_best_changed)
	gm.message_changed.connect(_on_message_changed)

func _on_points_changed(p: int) -> void:
	points_label.text = "Points: %d" % p

func _on_height_changed(h: int) -> void:
	height_label.text = "Height: %d" % h

func _on_best_changed(b: int) -> void:
	best_label.text = "Best: %d" % b

func _on_message_changed(t: String) -> void:
	message_label.text = t
