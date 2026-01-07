extends CharacterBody2D

enum Facing { LEFT, RIGHT }

@export var movement_speed: float = 70.0
@export var bullet_scene: PackedScene

var acceleration: int = 6
var friction: int = 20

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
	_spawn_bullet(direction)
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
	
	var lerp_weight: float = delta * (acceleration if input_dir == Vector2.ZERO else friction)
	velocity = lerp(velocity, input_dir * movement_speed, lerp_weight) #input_dir * movement_speed
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
	$FireSound.play()
