extends Node2D
## Draws the on-screen touch buttons. Hit-testing is done in main.gd
## using the same centers/radii, which are defined here.

const LEFT_CENTER := Vector2(110, 610)
const RIGHT_CENTER := Vector2(300, 610)
const JUMP_CENTER := Vector2(1170, 600)
const BUTTON_RADIUS := 80.0
const JUMP_RADIUS := 100.0

const FILL := Color(1, 1, 1, 0.18)
const ARROW := Color(1, 1, 1, 0.55)


func _draw() -> void:
	draw_circle(LEFT_CENTER, BUTTON_RADIUS, FILL)
	draw_circle(RIGHT_CENTER, BUTTON_RADIUS, FILL)
	draw_circle(JUMP_CENTER, JUMP_RADIUS, FILL)

	# Left arrow
	draw_colored_polygon(PackedVector2Array([
		LEFT_CENTER + Vector2(-34, 0),
		LEFT_CENTER + Vector2(20, -34),
		LEFT_CENTER + Vector2(20, 34),
	]), ARROW)
	# Right arrow
	draw_colored_polygon(PackedVector2Array([
		RIGHT_CENTER + Vector2(34, 0),
		RIGHT_CENTER + Vector2(-20, -34),
		RIGHT_CENTER + Vector2(-20, 34),
	]), ARROW)
	# Jump (up) arrow
	draw_colored_polygon(PackedVector2Array([
		JUMP_CENTER + Vector2(0, -40),
		JUMP_CENTER + Vector2(-38, 22),
		JUMP_CENTER + Vector2(38, 22),
	]), ARROW)
