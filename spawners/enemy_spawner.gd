class_name EnemySpawner
extends Node2D

@export var enemy_scene: PackedScene
@export var spawn_interval: float = 1.5
@export var max_enemies: int = 10
@export var spawn_radius: float = 100.0

@onready var enemy_container: Node2D = $EnemyContainer
@onready var spawn_timer: Timer = $SpawnTimer


func _ready() -> void:
	spawn_timer.wait_time = spawn_interval
	spawn_timer.timeout.connect(_spawn_enemy)
	spawn_timer.start()


func _spawn_enemy() -> void:
	if enemy_container.get_child_count() >= max_enemies:
		return

	var enemy: Enemy = enemy_scene.instantiate()
	enemy_container.add_child(enemy)
	enemy.global_position = global_position


func _random_spawn_position() -> Vector2:
	var angle := randf() * TAU
	var rand_radius := randf() * spawn_radius
	return global_position + Vector2.from_angle(angle) * rand_radius
