extends SceneTree


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	var packed := load("res://scenes/Main.tscn") as PackedScene
	var game := packed.instantiate()
	root.add_child(game)
	await physics_frame
	await physics_frame
	var level: Node3D = game.get("level")
	var player: CharacterBody3D = game.get("player")
	player.set_physics_process(false)

	level.set_active_area("courtyard")
	player.teleport(Vector3(4.8, 0.08, -8.65), 0)
	await physics_frame
	for _step in range(300):
		player.velocity = Vector3(0, -0.8, 1.8)
		player.move_and_slide()
		await physics_frame
	print("STAIR_FINAL position=", player.global_position)
	_check(player.global_position.y > 1.9, "Player climbs the stair ramp")
	_check(player.global_position.z > -5.2, "Player reaches the upper landing")

	level.set_active_area("bead")
	player.teleport(Vector3(-10.5, 0.08, -3.6), 0)
	await physics_frame
	var collision := player.move_and_collide(Vector3(0, 0, -3.4))
	_check(collision != null, "Beadwork table blocks the player")
	_check(collision.get_collider().name == "BeadTableCollider", "Beadwork table uses its intended collider")

	print("NAVIGATION_V3_SMOKE_PASS stairs=walkable table=blocking")
	game.queue_free()
	await process_frame
	quit(0)


func _check(condition: bool, label: String) -> void:
	if condition:
		return
	push_error("NAVIGATION_V3_SMOKE_FAIL: " + label)
	quit(1)
