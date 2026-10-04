extends Node2D
## Coin Dash: collect all the coins. Builds the whole level in code.

const PlayerScript := preload("res://player.gd")
const ControlsScript := preload("res://controls.gd")

const PLATFORMS: Array[Rect2] = [
	Rect2(0, 660, 1280, 60),    # ground
	Rect2(120, 550, 220, 24),
	Rect2(420, 450, 220, 24),
	Rect2(760, 360, 220, 24),
	Rect2(1020, 500, 200, 24),
]

const COINS: Array[Vector2] = [
	Vector2(80, 620), Vector2(330, 620), Vector2(600, 620),
	Vector2(900, 620), Vector2(1200, 620),
	Vector2(200, 510), Vector2(280, 510),
	Vector2(530, 410), Vector2(870, 320), Vector2(1120, 460),
]

const PLAYER_START := Vector2(640, 600)

var score := 0
var won := false
var touches := {}  # touch index -> position

var player: CharacterBody2D
var score_label: Label
var message_label: Label


func _ready() -> void:
	_setup_input_map()
	_build_platforms()
	_build_coins()
	_build_player()
	_build_hud()


func _setup_input_map() -> void:
	_add_key_action("move_left", [KEY_LEFT, KEY_A])
	_add_key_action("move_right", [KEY_RIGHT, KEY_D])
	_add_key_action("jump", [KEY_SPACE, KEY_UP, KEY_W])


func _add_key_action(action: String, keys: Array) -> void:
	if not InputMap.has_action(action):
		InputMap.add_action(action)
	for key in keys:
		var ev := InputEventKey.new()
		ev.physical_keycode = key
		InputMap.action_add_event(action, ev)


func _build_platforms() -> void:
	for rect in PLATFORMS:
		var body := StaticBody2D.new()
		body.position = rect.position + rect.size / 2.0

		var shape := CollisionShape2D.new()
		var box := RectangleShape2D.new()
		box.size = rect.size
		shape.shape = box
		body.add_child(shape)

		var half := rect.size / 2.0
		var visual := Polygon2D.new()
		visual.color = Color(0.3, 0.7, 0.35)
		visual.polygon = PackedVector2Array([
			Vector2(-half.x, -half.y), Vector2(half.x, -half.y),
			Vector2(half.x, half.y), Vector2(-half.x, half.y),
		])
		body.add_child(visual)

		add_child(body)


func _build_coins() -> void:
	for pos in COINS:
		var area := Area2D.new()
		area.position = pos

		var shape := CollisionShape2D.new()
		var circle := CircleShape2D.new()
		circle.radius = 16.0
		shape.shape = circle
		area.add_child(shape)

		var points := PackedVector2Array()
		for i in 16:
			var angle := TAU * i / 16.0
			points.append(Vector2(cos(angle), sin(angle)) * 14.0)
		var visual := Polygon2D.new()
		visual.color = Color(1.0, 0.85, 0.15)
		visual.polygon = points
		area.add_child(visual)

		area.body_entered.connect(_on_coin_body_entered.bind(area))
		add_child(area)


func _build_player() -> void:
	player = CharacterBody2D.new()
	player.set_script(PlayerScript)
	player.position = PLAYER_START
	player.set("spawn_position", PLAYER_START)
	add_child(player)


func _build_hud() -> void:
	var layer := CanvasLayer.new()
	add_child(layer)

	var controls := Node2D.new()
	controls.set_script(ControlsScript)
	layer.add_child(controls)

	score_label = Label.new()
	score_label.position = Vector2(24, 14)
	score_label.add_theme_font_size_override("font_size", 36)
	layer.add_child(score_label)
	_update_score_label()

	message_label = Label.new()
	message_label.position = Vector2(0, 260)
	message_label.size = Vector2(1280, 160)
	message_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	message_label.add_theme_font_size_override("font_size", 64)
	message_label.visible = false
	layer.add_child(message_label)


func _update_score_label() -> void:
	score_label.text = "Coins: %d / %d" % [score, COINS.size()]


func _on_coin_body_entered(body: Node2D, coin: Area2D) -> void:
	if body != player:
		return
	coin.queue_free()
	score += 1
	_update_score_label()
	if score >= COINS.size():
		won = true
		message_label.text = "You win!\nTap or press a key to play again"
		message_label.visible = true


func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed:
			touches[event.index] = event.position
			if won:
				get_tree().reload_current_scene()
		else:
			touches.erase(event.index)
	elif event is InputEventScreenDrag:
		touches[event.index] = event.position
	elif won and event is InputEventKey and event.pressed and not event.echo:
		get_tree().reload_current_scene()


func _physics_process(_delta: float) -> void:
	var dir := 0.0
	var jump := false
	for pos in touches.values():
		if pos.distance_to(ControlsScript.LEFT_CENTER) < ControlsScript.BUTTON_RADIUS + 30.0:
			dir -= 1.0
		elif pos.distance_to(ControlsScript.RIGHT_CENTER) < ControlsScript.BUTTON_RADIUS + 30.0:
			dir += 1.0
		elif pos.distance_to(ControlsScript.JUMP_CENTER) < ControlsScript.JUMP_RADIUS + 40.0:
			jump = true
	player.set("touch_dir", clampf(dir, -1.0, 1.0))
	player.set("touch_jump", jump)
