extends CharacterBody2D

signal player_died
signal player_jumped

const SPEED: float = 200.0
const JUMP_VELOCITY: float = -400.0
const MAX_FALL_SPEED: float = 600.0

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var wind_force: float = 0.0
var wind_direction: int = 1
var facing_right: bool = true

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var cape: Line2D = $Cape

func _physics_process(delta: float):
	# Apply gravity
	if not is_on_floor():
		velocity.y += gravity * delta
		if velocity.y > MAX_FALL_SPEED:
			velocity.y = MAX_FALL_SPEED
	
	# Handle jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		player_jumped.emit()
	
	# Handle horizontal movement
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		facing_right = direction > 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED * 0.5)
	
	# Apply wind force when in air
	if not is_on_floor():
		velocity.x += wind_force * wind_direction * delta * 100
	
	# Update sprite facing
	if sprite:
		sprite.flip_h = not facing_right
	
	# Update cape animation
	_update_cape()
	
	move_and_slide()

func set_wind(force: float, direction: int):
	wind_force = force
	wind_direction = direction

func _update_cape():
	if cape and not is_on_floor():
		# Animate cape based on wind
		var offset = wind_direction * wind_force * 0.1
		cape.set_point_position(1, Vector2(-offset * 2, 10))
		cape.set_point_position(2, Vector2(-offset * 3, 20))
		cape.visible = true
	elif cape:
		cape.visible = false

func die():
	player_died.emit()