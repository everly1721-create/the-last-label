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
	var level: Node3D = game.get("level")

	_check(_exists(level, "ArcadeTileSurface"), "Exterior has a tiled arcade surface")
	_check(_mesh_uses_texture(level, "ArcadeTileSurface", "peranakan_floor_v2.png"), "Exterior tile texture is assigned")

	level.set_active_area("front")
	await physics_frame
	_check(_mesh_uses_texture(level, "PeranakanTileSurface", "peranakan_floor_v2.png"), "Front hall floor texture is assigned")
	_check(_mesh_uses_texture(level, "LeongFamilyPhoto", "leong_family_1919.png"), "Family portrait uses the correct photograph")

	level.set_active_area("courtyard")
	await physics_frame
	for node_name in ["BeadworkDoorPanel", "KitchenDoorPanel", "StairRamp", "UpperGallery", "WellCollider"]:
		_check(_exists(level, node_name), "Courtyard contains " + node_name)
	_check(_ray_hits_named(game, Vector3(4.8, 5, -6.3), Vector3(4.8, 0, -6.3), "StairRamp"), "Stair ramp collision covers the steps")
	_check(_ray_hits_named(game, Vector3(-2, 0.45, -6.2), Vector3(2, 0.45, -6.2), "WellCollider"), "Well has blocking collision")

	level.set_active_area("bead")
	await physics_frame
	for node_name in ["BeadworkReturnDoorPanel", "BeadTableCollider", "VanityCollider", "ScreenCollider", "DressCollider"]:
		_check(_exists(level, node_name), "Beadwork room contains " + node_name)

	level.set_active_area("kitchen")
	await physics_frame
	for node_name in ["KitchenReturnDoorPanel", "StoveCollider", "TokPanjangCollider"]:
		_check(_exists(level, node_name), "Kitchen contains " + node_name)

	level.set_active_area("office")
	await physics_frame
	for node_name in ["OfficeReturnDoorPanel", "ContractCollider"]:
		_check(_exists(level, node_name), "Office contains " + node_name)

	level.set_active_area("ancestor")
	await physics_frame
	for node_name in ["AncestorReturnDoorPanel", "AltarCollider", "EvidenceCaseCollider"]:
		_check(_exists(level, node_name), "Ancestor hall contains " + node_name)

	print("ENVIRONMENT_V3_SMOKE_PASS textures=3 doors=6 stair=1 furniture_colliders=11")
	game.queue_free()
	await process_frame
	quit(0)


func _exists(root_node: Node, node_name: String) -> bool:
	return root_node.find_child(node_name, true, false) != null


func _mesh_uses_texture(root_node: Node, node_name: String, texture_name: String) -> bool:
	var mesh_instance := root_node.find_child(node_name, true, false) as MeshInstance3D
	if mesh_instance == null:
		return false
	var material := mesh_instance.get_active_material(0) as StandardMaterial3D
	return material != null and material.albedo_texture != null and material.albedo_texture.resource_path.ends_with(texture_name)


func _ray_hits_named(game: Node3D, from: Vector3, to: Vector3, expected_name: String) -> bool:
	var query := PhysicsRayQueryParameters3D.create(from, to, 1)
	query.collide_with_areas = false
	query.collide_with_bodies = true
	var result := game.get_world_3d().direct_space_state.intersect_ray(query)
	return not result.is_empty() and str(result.collider.name) == expected_name


func _check(condition: bool, label: String) -> void:
	if condition:
		return
	push_error("ENVIRONMENT_V3_SMOKE_FAIL: " + label)
	quit(1)
