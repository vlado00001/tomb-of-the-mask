extends Camera2D

@export var target: Node2D

func _process(_delta: float) -> void:
	if target == null:
		return
	var half: Vector2 = get_viewport_rect().size / 2.0
	global_position = Vector2(half.x, target.global_position.y if target else half.y)
