extends Node2D

const TILE: int = 16

@onready var camera: Camera2D = $Camera2D
@onready var ground: TileMapLayer = $Level/Ground
@onready var gm = get_node("/root/GameManager")


func _ready() -> void:
	gm.start_level(get_tree().get_nodes_in_group("collectibles").size())

	var used := ground.get_used_rect()
	camera.limit_top = used.position.y * TILE
	camera.limit_bottom = used.end.y * TILE
