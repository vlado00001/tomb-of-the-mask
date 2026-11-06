extends CharacterBody2D
@export var speed: float = 260.0
@export var checkpoint: Node2D

const TILE: float = 16.0

@onready var sprite: AnimatedSprite2D = $Sprite
@onready var trail: GPUParticles2D = $Trail
@onready var death_particles: GPUParticles2D = $DeathParticles
@onready var move_sound: AudioStreamPlayer = $MoveSound
@onready var hurt_sound: AudioStreamPlayer = $HurtSound

var moving := false
var dead := false
var direction := Vector2.ZERO
var start_y := 0.0
var _probe := KinematicCollision2D.new()
@onready var gm = get_node("/root/GameManager")


func _ready() -> void:
	if checkpoint:
		position = checkpoint.position
	start_y = position.y
	sprite.play("idle")


func _physics_process(delta: float) -> void:
	if dead or gm.finished:
		return

	if not moving:
		var dir := _read_input()
		if dir != Vector2.ZERO and _can_start(dir):
			_start_moving(dir)
	else:
		var col := move_and_collide(direction * speed * delta)
		if col:
			_on_hit(col.get_collider())

	gm.report_height(maxi(0, int((start_y - position.y) / TILE)))

func _read_input() -> Vector2:
	if Input.is_action_pressed("move_up"):
		return Vector2.UP
	if Input.is_action_pressed("move_down"):
		return Vector2.DOWN
	if Input.is_action_pressed("move_left"):
		return Vector2.LEFT
	if Input.is_action_pressed("move_right"):
		return Vector2.RIGHT
	return Vector2.ZERO

func _can_start(dir: Vector2) -> bool:
	if not test_move(global_transform, dir * 2.0, _probe):
		return true
	var c := _probe.get_collider()
	return c != null and c.is_in_group("spikes")


func _start_moving(dir: Vector2) -> void:
	moving = true
	direction = dir
	sprite.rotation = dir.angle() - PI / 2.0
	sprite.play("moving")
	trail.emitting = true
	move_sound.play()


func _on_hit(collider: Object) -> void:
	if collider != null and collider.is_in_group("spikes"):
		die()
	else:
		_land()


func _land() -> void:
	moving = false
	if direction.x != 0.0:
		position.x = snappedf(position.x - TILE / 2.0, TILE) + TILE / 2.0
	else:
		position.y = snappedf(position.y - TILE / 2.0, TILE) + TILE / 2.0
	trail.emitting = false
	sprite.play("idle")


func die() -> void:
	if dead or gm.finished:
		return
	dead = true
	moving = false
	trail.emitting = false
	sprite.play("death")
	death_particles.restart()
	death_particles.emitting = true
	hurt_sound.play()
	gm.player_died()
