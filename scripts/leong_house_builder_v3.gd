extends "res://scripts/leong_house_builder.gd"

const FLOOR_TEXTURE = preload("res://assets/textures/peranakan_floor_v2.png")
const PLASTER_TEXTURE = preload("res://assets/textures/aged_lime_plaster_v2.png")
const TEAK_TEXTURE = preload("res://assets/textures/dark_teak_v2.png")


func _build_exterior() -> void:
	super()
	_box(self, "ArcadeTileSurface", Vector3(0, 0.045, 15.5), Vector3(10.8, 0.045, 5.8), _floor_material(Color("d7d0b8"), Vector3(4.0, 4.0, 4.0)))
	_box(self, "FacadeLeftFinish", Vector3(-4.1, 3.2, 11.70), Vector3(5.68, 6.35, 0.035), _plaster_material(Color("aeb9ac"), Vector3(2.2, 2.2, 2.2)))
	_box(self, "FacadeRightFinish", Vector3(4.1, 3.2, 11.70), Vector3(5.68, 6.35, 0.035), _plaster_material(Color("aeb9ac"), Vector3(2.2, 2.2, 2.2)))
	_box(self, "FacadeLintelFinish", Vector3(0, 5.1, 11.70), Vector3(2.45, 2.55, 0.035), _plaster_material(Color("aeb9ac"), Vector3(1.0, 1.0, 1.0)))


func _build_front_hall() -> void:
	super()
	_add_wallpaper_panel_z("HallWallpaperRight", Vector3(4.25, 3.1, -1.79), Vector2(3.2, 2.75))
	for x in [-1.25, 1.25]:
		_box(self, "HallDoorRaisedPanel", Vector3(x, 1.8, -1.73), Vector3(1.7, 2.55, 0.07), _wood_material(Color("d0b496"), 0.67, Vector3(1.0, 1.0, 1.0)))


func _build_courtyard() -> void:
	super()
	_build_side_door("BeadworkDoor", Vector3(-5.79, 1.6, -5.1), false)
	_build_side_door("KitchenDoor", Vector3(5.79, 1.6, -5.1), true)
	for x in [-1.3, 1.3]:
		_box(self, "BackDoorRaisedPanel", Vector3(x, 1.75, -9.72), Vector3(1.72, 2.45, 0.07), _wood_material(Color("d0b496"), 0.67, Vector3.ONE))
	_sign(Vector3(-5.66, 3.65, -5.1), "BEADWORK\n珠绣房", Color("d7c690"), 20)
	_sign(Vector3(5.66, 3.65, -5.1), "KITCHEN\n厨房", Color("d7c690"), 20)
	_sign(Vector3(-1.3, 3.7, -9.70), "OFFICE\n账房", Color("d7c690"), 18)
	_sign(Vector3(1.3, 3.7, -9.70), "ANCESTOR HALL\n祖先厅", Color("d7c690"), 18)


func _build_beadwork_room() -> void:
	super()
	_build_side_door("BeadworkReturnDoor", Vector3(-7.19, 1.6, -5.1), true)
	_box_collider("BeadTableCollider", Vector3(-10.5, 0.48, -5.8), Vector3(2.85, 0.96, 1.55))


func _build_kitchen() -> void:
	super()
	_build_side_door("KitchenReturnDoor", Vector3(7.19, 1.6, -5.1), false)


func _build_office() -> void:
	super()
	_build_back_door("OfficeReturnDoor", Vector3(-4.0, 1.6, -11.18), 2.05)


func _build_ancestor_hall() -> void:
	super()
	_build_back_door("AncestorReturnDoor", Vector3(1.0, 1.6, -11.18), 2.05)


func _build_room_shell(prefix: String, center: Vector3, size: Vector2, upper_color: Color) -> void:
	super(prefix, center, size, upper_color)
	var tint := upper_color.lightened(0.58)
	var wall_material := _plaster_material(tint, Vector3(2.4, 2.4, 2.4))
	_box(self, prefix + "FloorFinish", center + Vector3(0, 0.025, 0), Vector3(size.x - 0.28, 0.04, size.y - 0.28), _floor_material(Color("d2c9ae"), Vector3(3.0, 3.0, 3.0)))
	_box(self, prefix + "NorthFinish", center + Vector3(0, 2.55, -size.y * 0.5 + 0.16), Vector3(size.x - 0.34, 4.45, 0.035), wall_material)
	_box(self, prefix + "SouthFinish", center + Vector3(0, 2.55, size.y * 0.5 - 0.16), Vector3(size.x - 0.34, 4.45, 0.035), wall_material)
	_box(self, prefix + "EastFinish", center + Vector3(size.x * 0.5 - 0.16, 2.55, 0), Vector3(0.035, 4.45, size.y - 0.34), wall_material)
	_box(self, prefix + "WestFinish", center + Vector3(-size.x * 0.5 + 0.16, 2.55, 0), Vector3(0.035, 4.45, size.y - 0.34), wall_material)


func _build_tile_field(center: Vector3, columns: int, rows: int, tile_size: float) -> void:
	var surface_size := Vector3(columns * tile_size, 0.045, rows * tile_size)
	_box(self, "PeranakanTileSurface", center + Vector3(0, 0.018, 0), surface_size, _floor_material(Color.WHITE, Vector3(columns / 2.0, rows / 2.0, rows / 2.0)))


func _build_staircase(position_value: Vector3) -> void:
	var step_count := 11
	var step_height := 0.23
	var step_depth := 0.32
	for index in range(step_count):
		var height := (index + 1) * step_height
		_box(self, "StairRiser", position_value + Vector3(0, height * 0.5, index * step_depth), Vector3(1.72, height, step_depth + 0.035), _wood_material(Color("bca78f"), 0.72, Vector3(1.4, 1.4, 1.4)))

	var total_rise := step_count * step_height
	var total_run := (step_count - 1) * step_depth + step_depth
	var slope_angle := atan2(total_rise, total_run)
	var slope_length := sqrt(total_rise * total_rise + total_run * total_run)
	var ramp_center := position_value + Vector3(0, total_rise * 0.5 + 0.02, total_run * 0.5 - step_depth * 0.5)
	_rotated_box_collider("StairRamp", ramp_center, Vector3(1.5, 0.16, slope_length), Vector3(-slope_angle, 0, 0))
	for side in [-0.88, 0.88]:
		_rotated_box_collider("StairGuard", ramp_center + Vector3(side, 0.65, 0), Vector3(0.12, 1.28, slope_length), Vector3(-slope_angle, 0, 0))
		_add_sloped_rail(position_value + Vector3(side, total_rise * 0.5 + 0.82, total_run * 0.5 - step_depth * 0.5), slope_length, slope_angle)

	var landing_center := position_value + Vector3(0, total_rise - 0.11, total_run + 0.92)
	_static_box("UpperGallery", landing_center, Vector3(1.9, 0.22, 2.15), _wood_material(Color("bca78f"), 0.75, Vector3(1.4, 1.4, 1.4)))
	_static_box("UpperGalleryGuard", landing_center + Vector3(-1.0, 0.72, 0), Vector3(0.12, 1.4, 2.15), _wood_material(Color("8c715b"), 0.74, Vector3.ONE))


func _build_blackwood_chair(position_value: Vector3, yaw: float) -> void:
	super(position_value, yaw)
	_box_collider("ChairCollider", position_value + Vector3(0, 0.72, 0), Vector3(1.05, 1.44, 1.0), Vector3(0, deg_to_rad(yaw), 0))


func _build_display_cabinet(position_value: Vector3, yaw: float) -> void:
	super(position_value, yaw)
	_box_collider("CabinetCollider", position_value + Vector3(0, 0, 0), Vector3(0.78, 2.5, 1.5))


func _build_console_table(position_value: Vector3, yaw: float) -> void:
	super(position_value, yaw)
	_box_collider("ConsoleCollider", position_value + Vector3(0, 0.48, 0), Vector3(0.78, 0.96, 2.72))


func _build_grandfather_clock(position_value: Vector3) -> void:
	super(position_value)
	_box_collider("ClockCollider", position_value + Vector3(0, 1.5, 0), Vector3(0.9, 3.0, 0.58))


func _build_letter_case(position_value: Vector3) -> void:
	super(position_value)
	_box_collider("LetterCaseCollider", position_value + Vector3(0, 0.72, 0), Vector3(1.65, 1.44, 0.84))


func _build_well(position_value: Vector3) -> void:
	super(position_value)
	_cylinder_collider("WellCollider", position_value + Vector3(0, 0.46, 0), 0.94, 0.92)


func _build_vanity(position_value: Vector3) -> void:
	super(position_value)
	_box_collider("VanityCollider", position_value + Vector3(0, 0.74, 0), Vector3(2.05, 1.48, 0.76))


func _build_folding_screen(position_value: Vector3) -> void:
	super(position_value)
	_box_collider("ScreenCollider", position_value + Vector3(0.82, 1.35, 0), Vector3(2.5, 2.7, 0.32))


func _build_dress_stand(position_value: Vector3) -> void:
	super(position_value)
	_box_collider("DressCollider", position_value + Vector3(0, 1.2, 0), Vector3(1.0, 2.4, 0.56))


func _build_stove(position_value: Vector3) -> void:
	super(position_value)
	_box_collider("StoveCollider", position_value + Vector3(0, 0.72, 0), Vector3(1.65, 1.44, 1.05))


func _build_tok_panjang(position_value: Vector3) -> void:
	super(position_value)
	_box_collider("TokPanjangCollider", position_value + Vector3(0, 0.46, 0), Vector3(3.25, 0.92, 1.5))


func _build_rubber_contracts(position_value: Vector3) -> void:
	super(position_value)
	_box_collider("ContractCollider", position_value + Vector3(0, 1.0, 0), Vector3(1.45, 2.0, 0.66))


func _build_altar(position_value: Vector3) -> void:
	super(position_value)
	_box_collider("AltarCollider", position_value + Vector3(0, 1.08, 0.12), Vector3(5.45, 2.2, 1.35))


func _build_evidence_case(position_value: Vector3) -> void:
	super(position_value)
	_box_collider("EvidenceCaseCollider", position_value + Vector3(0, 0.82, 0), Vector3(3.05, 1.64, 1.55))


func _wall_material() -> StandardMaterial3D:
	return _plaster_material(Color("b3b9ad"), Vector3(2.6, 2.6, 2.6))


func _material(color: Color, roughness: float) -> StandardMaterial3D:
	if color == wood or color == wood_highlight or color == Color("1a1210") or color == Color("453428"):
		return _wood_material(color.lightened(0.42), roughness, Vector3(1.6, 1.6, 1.6))
	return super(color, roughness)


func _floor_material(tint: Color, uv_scale: Vector3) -> StandardMaterial3D:
	return _surface_material("floor_" + tint.to_html() + "_" + str(uv_scale), FLOOR_TEXTURE, tint, 0.78, uv_scale)


func _plaster_material(tint: Color, uv_scale: Vector3) -> StandardMaterial3D:
	return _surface_material("plaster_" + tint.to_html() + "_" + str(uv_scale), PLASTER_TEXTURE, tint, 0.94, uv_scale)


func _wood_material(tint: Color, roughness: float, uv_scale: Vector3) -> StandardMaterial3D:
	return _surface_material("teak_" + tint.to_html() + "_" + str(roughness) + "_" + str(uv_scale), TEAK_TEXTURE, tint, roughness, uv_scale)


func _surface_material(key: String, texture: Texture2D, tint: Color, roughness: float, uv_scale: Vector3) -> StandardMaterial3D:
	if material_cache.has(key):
		return material_cache[key]
	var material := StandardMaterial3D.new()
	material.albedo_texture = texture
	material.albedo_color = tint
	material.roughness = roughness
	material.uv1_scale = uv_scale
	material.texture_filter = BaseMaterial3D.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS_ANISOTROPIC
	material.texture_repeat = true
	material_cache[key] = material
	return material


func _build_side_door(node_name: String, position_value: Vector3, faces_left: bool) -> void:
	var panel_material := _wood_material(Color("b39a82"), 0.68, Vector3(1.1, 1.1, 1.1))
	_box(self, node_name + "Panel", position_value, Vector3(0.10, 3.2, 2.25), panel_material)
	var face_offset := -0.07 if faces_left else 0.07
	for y_offset in [-0.78, 0.78]:
		_box(self, node_name + "RaisedPanel", position_value + Vector3(face_offset, y_offset, 0), Vector3(0.06, 1.15, 1.62), _wood_material(Color("d0b496"), 0.67, Vector3.ONE))
	for z_offset in [-1.18, 1.18]:
		_box(self, node_name + "Frame", position_value + Vector3(0, 0, z_offset), Vector3(0.18, 3.45, 0.14), panel_material)
	for y_offset in [-1.68, 1.68]:
		_box(self, node_name + "Frame", position_value + Vector3(0, y_offset, 0), Vector3(0.18, 0.14, 2.5), panel_material)
	var knob_x := -0.09 if faces_left else 0.09
	_cylinder(self, node_name + "Knob", position_value + Vector3(knob_x, 0, -0.62), 0.07, 0.18, _metal(brass), Vector3(0, 0, 90))


func _build_back_door(node_name: String, position_value: Vector3, width: float) -> void:
	var panel_material := _wood_material(Color("b39a82"), 0.68, Vector3(1.1, 1.1, 1.1))
	_box(self, node_name + "Panel", position_value, Vector3(width, 3.2, 0.10), panel_material)
	for y_offset in [-0.78, 0.78]:
		_box(self, node_name + "RaisedPanel", position_value + Vector3(0, y_offset, 0.07), Vector3(width * 0.72, 1.15, 0.06), _wood_material(Color("d0b496"), 0.67, Vector3.ONE))
	for x_offset in [-width * 0.54, width * 0.54]:
		_box(self, node_name + "Frame", position_value + Vector3(x_offset, 0, 0), Vector3(0.14, 3.45, 0.18), panel_material)
	for y_offset in [-1.68, 1.68]:
		_box(self, node_name + "Frame", position_value + Vector3(0, y_offset, 0), Vector3(width + 0.24, 0.14, 0.18), panel_material)
	_cylinder(self, node_name + "Knob", position_value + Vector3(width * 0.3, 0, 0.1), 0.07, 0.18, _metal(brass), Vector3(90, 0, 0))


func _add_wallpaper_panel_z(node_name: String, position_value: Vector3, size: Vector2) -> void:
	var material := StandardMaterial3D.new()
	material.albedo_texture = WALLPAPER_TEXTURE
	material.roughness = 0.9
	material.uv1_scale = Vector3(1.25, 1.25, 1.25)
	material.texture_repeat = true
	_box(self, node_name, position_value, Vector3(size.x, size.y, 0.025), material)


func _add_sloped_rail(position_value: Vector3, length: float, slope_angle: float) -> void:
	var rail := Node3D.new()
	rail.position = position_value
	rail.rotation.x = -slope_angle
	_scene_parent().add_child(rail)
	_box(rail, "SlopedHandrail", Vector3.ZERO, Vector3(0.11, 0.11, length), _wood_material(Color("a98f76"), 0.7, Vector3.ONE))


func _box_collider(node_name: String, position_value: Vector3, size: Vector3, rotation_value: Vector3 = Vector3.ZERO) -> StaticBody3D:
	return _rotated_box_collider(node_name, position_value, size, rotation_value)


func _rotated_box_collider(node_name: String, position_value: Vector3, size: Vector3, rotation_value: Vector3) -> StaticBody3D:
	var body := StaticBody3D.new()
	body.name = node_name
	body.position = position_value
	body.rotation = rotation_value
	body.collision_layer = 1
	body.collision_mask = 1
	var collider := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = size
	collider.shape = shape
	body.add_child(collider)
	_scene_parent().add_child(body)
	return body


func _cylinder_collider(node_name: String, position_value: Vector3, radius: float, height: float) -> StaticBody3D:
	var body := StaticBody3D.new()
	body.name = node_name
	body.position = position_value
	body.collision_layer = 1
	body.collision_mask = 1
	var collider := CollisionShape3D.new()
	var shape := CylinderShape3D.new()
	shape.radius = radius
	shape.height = height
	collider.shape = shape
	body.add_child(collider)
	_scene_parent().add_child(body)
	return body
