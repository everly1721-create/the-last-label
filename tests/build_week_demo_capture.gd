extends SceneTree


const FPS := 24

var game: Node
var player: CharacterBody3D
var fade_rect: ColorRect
var shot_label: Label


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	var packed := load("res://scenes/Main.tscn") as PackedScene
	game = packed.instantiate()
	root.add_child(game)
	for _frame in range(12):
		await process_frame

	game.call("_set_language", "en", false)
	player = game.get("player") as CharacterBody3D
	player.call("set_controls_enabled", false)
	player.set_physics_process(false)
	game.set_process(false)
	game.get("prompt_label").visible = false
	_build_capture_overlay()

	var narration := AudioStreamPlayer.new()
	narration.stream = load("res://media/demo_narration.wav")
	root.add_child(narration)
	narration.play()

	await _fade(1.0, 0.0, 18)
	await _hold(4.0)
	await _fade(0.0, 1.0, 12)
	game.get("title_overlay").visible = false
	game.get("dialog_panel").visible = false

	await _shot("FRONT HALL / THE CHANGING ARCHIVE", "front", Vector3(0, 0.05, 10.2), 0.0, Vector3(0, 0, -2.2), 8.0)
	await _shot("THE LEONG FAMILY / 1919", "front", Vector3(-0.6, 0.05, 3.9), -18.0, Vector3(-0.35, 0, -0.8), 7.0)
	await _shot("COURTYARD / RAIN AND UPPER GALLERY", "courtyard", Vector3(0, 0.05, -3.1), 0.0, Vector3(0, 0, -0.7), 8.0)
	await _shot("BEADWORK ROOM / MOTIFS AS CIPHER", "bead", Vector3(-7.6, 0.05, -5.1), 90.0, Vector3(0.7, 0, 0), 8.0)
	await _shot("KITCHEN / THE FINAL BANQUET", "kitchen", Vector3(7.6, 0.05, -5.1), -90.0, Vector3(-0.7, 0, 0), 8.0)
	await _shot("COUNTING ROOM / THREE LEDGERS", "office", Vector3(-6.0, 0.05, -11.7), 0.0, Vector3(0, 0, -0.5), 8.0)
	await _shot("ANCESTOR HALL / FIVE PIECES OF EVIDENCE", "ancestor", Vector3(3.0, 0.05, -11.7), 0.0, Vector3(0, 0, -0.5), 9.0)

	shot_label.anchor_top = 0.5
	shot_label.anchor_bottom = 0.5
	shot_label.offset_top = -100
	shot_label.offset_bottom = 100
	shot_label.text = "THREE ENDINGS\nTRUTH  |  A BEAUTIFUL LIE  |  BURN THE LEDGERS\n\nBUILT WITH CODEX + GPT-5.6"
	shot_label.add_theme_font_size_override("font_size", 28)
	await _fade(1.0, 0.0, 18)
	await _hold(6.0)
	await _fade(0.0, 1.0, 18)
	print("BUILD_WEEK_DEMO_CAPTURE_PASS")
	game.queue_free()
	await process_frame
	quit(0)


func _build_capture_overlay() -> void:
	var canvas := CanvasLayer.new()
	canvas.layer = 100
	root.add_child(canvas)
	shot_label = Label.new()
	shot_label.set_anchors_preset(Control.PRESET_BOTTOM_WIDE)
	shot_label.offset_left = 42
	shot_label.offset_right = -42
	shot_label.offset_top = -118
	shot_label.offset_bottom = -34
	shot_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	shot_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	shot_label.add_theme_font_size_override("font_size", 24)
	shot_label.add_theme_color_override("font_color", Color("f2dfaa"))
	shot_label.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.95))
	shot_label.add_theme_constant_override("shadow_offset_x", 2)
	shot_label.add_theme_constant_override("shadow_offset_y", 2)
	canvas.add_child(shot_label)
	fade_rect = ColorRect.new()
	fade_rect.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	fade_rect.color = Color.BLACK
	fade_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	canvas.add_child(fade_rect)


func _shot(label_text: String, area: String, start: Vector3, yaw: float, travel: Vector3, duration: float) -> void:
	fade_rect.color.a = 1.0
	game.get("level").call("set_active_area", area)
	player.call("teleport", start, yaw)
	player.call("_play_animation", "Walk", 0.62)
	shot_label.text = label_text
	for _frame in range(18):
		await process_frame
	await _fade(1.0, 0.0, 12)
	var frame_count := int(duration * FPS)
	for frame in range(frame_count):
		var t := float(frame) / maxf(1.0, float(frame_count - 1))
		var smooth_t := t * t * (3.0 - 2.0 * t)
		var position := start + travel * smooth_t
		var camera_yaw := deg_to_rad(yaw + lerpf(-5.0, 7.0, smooth_t))
		player.global_position = position
		player.rotation.y = deg_to_rad(yaw)
		player.set("last_safe_position", position)
		var rig := player.get("camera_rig") as Node3D
		if is_instance_valid(rig):
			rig.global_position = position + Vector3(0, 1.47, 0)
			rig.rotation.y = camera_yaw
		await process_frame
	await _fade(0.0, 1.0, 12)


func _fade(from: float, to: float, frames: int) -> void:
	for frame in range(frames):
		var t := float(frame + 1) / float(frames)
		fade_rect.color.a = lerpf(from, to, t)
		await process_frame


func _hold(seconds: float) -> void:
	for _frame in range(int(seconds * FPS)):
		await process_frame
