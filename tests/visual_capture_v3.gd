extends SceneTree


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	var packed := load("res://scenes/Main.tscn") as PackedScene
	var game := packed.instantiate()
	root.add_child(game)
	for _frame in range(3):
		await process_frame
	game.call("_set_language", "en", false)
	game.get("title_overlay").visible = false
	game.get("dialog_panel").visible = false
	game.get("player").set_controls_enabled(false)

	var captures := [
		["front", Vector3(0, 0.05, 10.2), 0.0],
		["courtyard", Vector3(0, 0.05, -3.1), 0.0],
		["bead", Vector3(-7.6, 0.05, -5.1), 90.0],
		["kitchen", Vector3(7.6, 0.05, -5.1), -90.0],
		["office", Vector3(-6, 0.05, -11.7), 0.0],
		["ancestor", Vector3(3, 0.05, -11.7), 0.0],
	]
	for capture in captures:
		game.get("level").set_active_area(capture[0])
		game.get("player").teleport(capture[1], capture[2])
		for _frame in range(50):
			await process_frame
		var image := root.get_viewport().get_texture().get_image()
		image.save_png("res://qa_%s_v3.png" % capture[0])

	print("VISUAL_CAPTURE_V3_PASS scenes=6")
	game.queue_free()
	await process_frame
	quit(0)
