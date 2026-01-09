class_name Bullet
extends Area2D

@export var speed: float = 900.0
@export var damage: int = 1
@export var lifetime: float = 3.0

var velocity: Vector2
var alive: bool = true

func _ready() -> void:
	$Sprite.modulate = Color("49e7ec")
	$Sprite/Trail.modulate = Color("49e7ec")
	monitoring = true
	
	if velocity != Vector2.ZERO:
		rotation = velocity.angle()
	
	if lifetime > 0:
		await get_tree().create_timer(lifetime).timeout
		queue_free()

func _physics_process(delta: float) -> void:
	position += velocity * delta

func _on_body_entered(body: Node2D) -> void:
	if not alive:
		return
		
	alive = false
	set_deferred("monitoring", false)
	
	if body.is_in_group("enemies"):
		_hit_enemy(body)
	elif body.is_in_group("walls"):
		_hit_wall(body)

func _hit_enemy(body: Node2D) -> void:
	var enemy: Enemy = body as Enemy
	if enemy.has_method("take_hit"):
		enemy.take_hit(damage, velocity)
	queue_free()

func _hit_wall(_body: Node2D) -> void:
	queue_free()
