extends StaticBody2D

@export var is_finish: bool = false
@export var is_moving: bool = false
@export var move_range: float = 50.0
@export var move_speed: float = 2.0

var original_position: Vector2
var move_offset: float = 0.0

signal finish_reached

func _ready():
	original_position = position
	
	if is_finish:
		# Connect area for finish detection
		var area = $FinishArea
		if area:
			area.body_entered.connect(_on_finish_area_entered)

func _process(delta: float):
	if is_moving:
		move_offset += move_speed * delta
		position.x = original_position.x + sin(move_offset) * move_range

func _on_finish_area_entered(body: Node2D):
	if body.name == "Player":
		finish_reached.emit()