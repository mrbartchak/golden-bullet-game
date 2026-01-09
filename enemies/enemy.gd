class_name Enemy
extends CharacterBody2D

@export var max_health: int = 3
@export var movement_speed: float = 30.0

var health: int
var movement_direction: Vector2
var alive: bool = true

var wobble_strength: float = 0.4
var wobble_speed: float = 2.0
var wobble_time: float = 0.0

var knockback_strength: float = 60.0
var knockback_friction: float = 800.0
var knockback_velocity: Vector2 = Vector2.ZERO

var player: Player


func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	health = max_health
	$HitFlashTimer.timeout.connect(_on_hit_flash_timeout)

func _process(_delta: float) -> void:
	_update_movement_animation()

func _physics_process(delta: float) -> void:
	if not alive or player == null:
		_apply_knockback(delta)
		move_and_slide()
		return
	_handle_movement(delta)
	_apply_knockback(delta)
	move_and_slide()


#=== Public Functions ===
func take_hit(amount: int, hit_direction: Vector2) -> void:
	if not alive:
		return
	knockback_velocity += hit_direction.normalized() * knockback_strength
	health -= amount
	_play_hit_flash()
	if health <= 0:
		die()

func die() -> void:
	alive = false
	#$CollisionShape2D.set_deferred("disabled", true)
	#$Sprite.visible = false
	_play_death_sound()
	_play_death_particles()
	await get_tree().create_timer($DeathParticles.lifetime).timeout
	queue_free()


#=== Private Functions ===
func _handle_movement(delta: float) -> void:
	wobble_time += delta * wobble_speed
	
	var to_player: Vector2 = (player.global_position - global_position).normalized()
	var wobble: Vector2 = Vector2(
		sin(wobble_time),
		cos(wobble_time)
	) * wobble_strength
	
	movement_direction = (to_player + wobble).normalized()
	velocity = movement_direction * movement_speed

func _apply_knockback(delta: float) -> void:
	knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, knockback_friction * delta)
	velocity += knockback_velocity


#=== Effects & Visuals ===
func _update_movement_animation() -> void:
	if movement_direction == Vector2.ZERO:
		$Sprite.play("idle")
		return
	
	if movement_direction.x < 0:
		$Sprite.play("move_left")
	elif movement_direction.x > 0:
		$Sprite.play("move_right")

func _play_hit_flash() -> void:
	$Sprite.modulate = Color("f6757a")
	$HitFlashTimer.start()

func _play_death_sound() -> void:
	$DeathAudio.pitch_scale = randf_range(0.8, 1.2)
	$DeathAudio.play()

func _play_death_particles() -> void:
	$DeathParticles.modulate = Color("ff4f69")
	$DeathParticles.emitting = true

func _on_hit_flash_timeout() -> void:
	$Sprite.modulate = Color.WHITE
