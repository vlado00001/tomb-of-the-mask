extends Area2D

@export var rise_speed: float = 50.0
@export var start_delay: float = 3.0

var _time: float = 0.0
@onready var gm = get_node("/root/GameManager")


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _physics_process(delta: float) -> void:
	if gm.finished:
		return
	_time += delta
	if _time >= start_delay:
		position.y -= rise_speed * delta


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and body.has_method("die"):
		body.die()
