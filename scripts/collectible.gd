extends Area2D

signal collected(points: int)

@export var points: int = 1
@export var pickup_effect: PackedScene

var _taken := false
@onready var gm = get_node("/root/GameManager")


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	collected.connect(gm.on_collected)


func _on_body_entered(body: Node2D) -> void:
	if _taken or not body.is_in_group("player"):
		return
	_taken = true
	$CollisionShape2D.set_deferred("disabled", true)
	collected.emit(points)

	if pickup_effect:
		var fx := pickup_effect.instantiate()
		fx.points = points
		fx.position = position
		get_parent().add_child.call_deferred(fx)
	queue_free()
