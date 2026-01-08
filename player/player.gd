class_name Player
extends CharacterBody2D

enum Facing { LEFT, RIGHT }

@export var bullet_scene: PackedScene

var movement_speed: float = 150.0
var acceleration: int = 10
var friction: int = 12

var facing: Facing = Facing.RIGHT
var muzzle_offset: int = 4

#===Process Callbacks
func _ready() -> void:
	$Sprite.play("idle")
	self.modulate = Color.GOLD

func _process(_delta: float) -> void:
	_update_animation()
	
	if Input.is_action_just_pressed("fire"):
		fire()

func _physics_process(delta: float) -> void:
	_handle_movement(delta)


#===Public Functions
func fire() -> void:
	var mouse_pos: Vector2 = get_global_mouse_position()
	var direction: Vector2 = (mouse_pos - global_position).normalized()
	var bullet_spread: float = deg_to_rad(3.0)
	var spread_angle: float = randf_range(-bullet_spread, bullet_spread)
	_spawn_bullet(direction.rotated(spread_angle))
	_play_fire_sound()


#===Private Functions
func _handle_movement(delta: float) -> void:
	var input_dir: Vector2 = Input.get_vector(
		"move_left",
		"move_right",
		"move_up",
		"move_down"
	)
	
	if input_dir.x > 0:
		facing = Facing.RIGHT
	elif input_dir.x < 0:
		facing = Facing.LEFT
	
	var lerp_weight: float = delta * (friction if input_dir == Vector2.ZERO else acceleration)
	velocity = lerp(velocity, input_dir * movement_speed, lerp_weight) #input_dir * movement_speed
	
	if velocity.length() < 3.0:
		velocity = Vector2.ZERO
	
	move_and_slide()

func _update_animation() -> void:
	if velocity.length_squared() == 0:
		$Sprite.play("idle")
		return
	
	if facing == Facing.RIGHT:
		$Sprite.play("run_left")
	else:
		$Sprite.play("run_right")

func _spawn_bullet(direction: Vector2) -> void:
	var bullet: Bullet = bullet_scene.instantiate()
	bullet.global_position = global_position + (direction * muzzle_offset)
	bullet.velocity = direction * bullet.speed
	get_tree().current_scene.add_child(bullet)


#===Effects===
func _play_fire_sound() -> void:
	$FireSound.pitch_scale = randf_range(0.6, 1.4)
	$FireSound.play()
