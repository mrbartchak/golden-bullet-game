class_name EnemySpawner
extends Node2D

@export var enemy_scene: PackedScene
@export var spawn_interval: float = 1.5
@export var max_enemies: int = 10

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
	enemy.global_position = get_random_spawn_position()


func get_random_spawn_position() -> Vector2:
	var spawn_area: Area2D = $SpawnArea
	var shape: RectangleShape2D = $SpawnArea/CollisionShape2D.shape
	var size: Vector2 = shape.size
	return spawn_area.global_position + Vector2(
		randf_range(-size.x * 0.5, size.x * 0.5),
		randf_range(-size.y * 0.5, size.y * 0.5)
	)
