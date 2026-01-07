class_name Enemy
extends CharacterBody2D

@export var max_health: int = 3
@export var movement_speed: float = 3.0

var health: int
var movement_direction: Vector2
var alive: bool = true


func _ready() -> void:
	health = max_health
	var screen_center = get_viewport_rect().size * 0.5
	movement_direction = (screen_center - global_position).normalized()
	$HitFlashTimer.timeout.connect(_on_hit_flash_timeout)

func _physics_process(delta: float) -> void:
	global_position += movement_direction * movement_speed * delta

func take_damage(amount: int) -> void:
	if not alive:
		return
	health -= amount
	_play_hit_flash()
	if health <= 0:
		die()

func die() -> void:
	alive = false
	$CollisionShape2D.set_deferred("disabled", true)
	$Sprite.visible = false
	_play_death_animation()
	await get_tree().create_timer($DeathParticles.lifetime).timeout
	queue_free()

#=== Visuals ===
func _play_hit_flash() -> void:
	$Sprite.modulate = Color("f6757a")
	$HitFlashTimer.start()

func _play_death_animation() -> void:
	$DeathParticles.modulate = Color.KHAKI
	$DeathParticles.emitting = true

func _on_hit_flash_timeout() -> void:
	$Sprite.modulate = Color.WHITE
