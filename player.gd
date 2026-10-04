extends CharacterBody2D
## Simple platformer player: run left/right and jump.
## Keyboard input comes from the InputMap; touch input is pushed in by main.gd.

const SPEED := 420.0
const JUMP_VELOCITY := -760.0
const GRAVITY := 1900.0
const FALL_LIMIT := 900.0

var touch_dir := 0.0
var touch_jump := false
var spawn_position := Vector2.ZERO

var _touch_jump_prev := false


func _ready() -> void:
	var shape := CollisionShape2D.new()
	var rect := RectangleShape2D.new()
	rect.size = Vector2(40, 56)
	shape.shape = rect
	add_child(shape)

	var body := Polygon2D.new()
	body.color = Color(0.35, 0.8, 1.0)
	body.polygon = PackedVector2Array([
		Vector2(-20, -28), Vector2(20, -28), Vector2(20, 28), Vector2(-20, 28)
	])
	add_child(body)

	var eye := Polygon2D.new()
	eye.color = Color.WHITE
	eye.polygon = PackedVector2Array([
		Vector2(4, -16), Vector2(14, -16), Vector2(14, -6), Vector2(4, -6)
	])
	add_child(eye)


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	var dir := Input.get_axis("move_left", "move_right")
	if is_zero_approx(dir):
		dir = touch_dir
	velocity.x = dir * SPEED

	var jump_pressed := Input.is_action_just_pressed("jump") \
		or (touch_jump and not _touch_jump_prev)
	_touch_jump_prev = touch_jump
	if jump_pressed and is_on_floor():
		velocity.y = JUMP_VELOCITY

	move_and_slide()

	if global_position.y > FALL_LIMIT:
		respawn()


func respawn() -> void:
	global_position = spawn_position
	velocity = Vector2.ZERO
