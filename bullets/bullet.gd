class_name Bullet
extends Area2D

@export var speed: float = 900.0
@export var damage: int = 1
@export var lifetime: float = 3.0

var velocity: Vector2
var alive: bool = true

func _ready() -> void:
	monitoring = true
	
	if lifetime > 0:
		await get_tree().create_timer(lifetime).timeout
		queue_free()

func _physics_process(delta: float) -> void:
	position += velocity * delta

func _on_body_entered(body: Node2D) -> void:
	if not alive:
		return
	if not body.is_in_group("enemies"):
		return
	
	alive = false
	set_deferred("monitoring", false)
	
	if body.has_method("take_damage"):
		body.take_damage(damage)
	
	queue_free()
