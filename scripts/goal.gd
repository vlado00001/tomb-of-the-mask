extends Area2D

@onready var gm = get_node("/root/GameManager")


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		gm.win()
