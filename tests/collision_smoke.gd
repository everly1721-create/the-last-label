extends SceneTree


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	var packed := load("res://scenes/Main.tscn") as PackedScene
	_check(packed != null, "Main scene loads")
	var game := packed.instantiate()
	root.add_child(game)
	await physics_frame
	await physics_frame

	_check(_ray_hits_world(game, Vector3(0, 1.2, 13.2), Vector3(0, 1.2, 11.2)), "Exterior door blocks walking through")

	game.call("_enter_front_hall")
	await physics_frame
	_check(_ray_hits_world(game, Vector3(0, 1.2, -0.8), Vector3(0, 1.2, -2.8)), "Front hall courtyard door blocks walking through")
	_check(_ray_hits_world(game, Vector3(-4.25, 2.8, -0.8), Vector3(-4.25, 2.8, -2.8)), "Family photo has a solid wall behind it")

	game.get("flags")["front_complete"] = true
	game.call("_enter_courtyard")
	await physics_frame
	_check(_ray_hits_world(game, Vector3(0, 1.2, -8.8), Vector3(0, 1.2, -10.8)), "Courtyard back doors block walking through")

	var player: CharacterBody3D = game.get("player")
	player.teleport(Vector3(0, 0.05, -6))
	player.global_position = Vector3(0, -8, -6)
	player.call("_physics_process", 0.016)
	_check(player.global_position.y > 0.0, "Fall recovery returns player to safe ground")

	print("COLLISION_SMOKE_PASS portals=4 fall_recovery=1")
	game.queue_free()
	await process_frame
	quit(0)


func _ray_hits_world(game: Node3D, from: Vector3, to: Vector3) -> bool:
	var query := PhysicsRayQueryParameters3D.create(from, to, 1)
	query.collide_with_areas = false
	query.collide_with_bodies = true
	return not game.get_world_3d().direct_space_state.intersect_ray(query).is_empty()


func _check(condition: bool, label: String) -> void:
	if condition:
		return
	push_error("COLLISION_SMOKE_FAIL: " + label)
	quit(1)
