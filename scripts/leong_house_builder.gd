extends Node3D

const FAMILY_TEXTURE = preload("res://assets/textures/leong_family_1919.png")
const YUECHENG_TEXTURE = preload("res://assets/textures/liang_yuecheng_1919.png")
const WALLPAPER_TEXTURE = preload("res://assets/textures/aged_peony_wallpaper.png")

var family_photo: MeshInstance3D
var yuecheng_photo: MeshInstance3D
var exhibit_lights: Array[OmniLight3D] = []
var night_mode := false
var room_roots := {}
var active_room_root: Node3D
var material_cache := {}

var wood := Color("241813")
var wood_highlight := Color("4b3022")
var brass := Color("a6813c")
var jade := Color("244c48")
var burgundy := Color("5c232b")
var porcelain := Color("d8d4c4")


func build() -> void:
	_build_environment()
	_ensure_area("outside")
	set_active_area("outside")


func _begin_area(area_id: String) -> void:
	var root := Node3D.new()
	root.name = "Area_" + area_id
	self.add_child(root)
	room_roots[area_id] = root
	active_room_root = root


func set_active_area(area_id: String) -> void:
	_ensure_area(area_id)
	for key in room_roots:
		var root: Node3D = room_roots[key]
		root.visible = str(key) == area_id


func _ensure_area(area_id: String) -> void:
	if room_roots.has(area_id):
		return
	_begin_area(area_id)
	match area_id:
		"outside": _build_exterior()
		"front": _build_front_hall()
		"courtyard": _build_courtyard()
		"bead": _build_beadwork_room()
		"kitchen": _build_kitchen()
		"office": _build_office()
		"ancestor": _build_ancestor_hall()
	active_room_root = null

func _scene_parent() -> Node3D:
	return active_room_root if is_instance_valid(active_room_root) else self


func _resolve_parent(requested_parent: Node3D) -> Node3D:
	if requested_parent == self and is_instance_valid(active_room_root):
		return active_room_root
	return requested_parent

func set_photo_stage(stage: int) -> void:
	if not is_instance_valid(family_photo) or not is_instance_valid(yuecheng_photo):
		return
	if stage < 5:
		family_photo.visible = true
		yuecheng_photo.visible = false
		var photo_quad := family_photo.mesh as QuadMesh
		if photo_quad and photo_quad.material is StandardMaterial3D:
			var photo_material := photo_quad.material as StandardMaterial3D
			photo_material.albedo_color = Color(1.0 - stage * 0.07, 1.0 - stage * 0.08, 1.0 - stage * 0.09, 1.0)
	else:
		family_photo.visible = false
		yuecheng_photo.visible = true


func set_night_mode(enabled: bool) -> void:
	night_mode = enabled
	for light in exhibit_lights:
		if is_instance_valid(light):
			light.light_energy = 1.25 if enabled else 2.25
	var environment_node := get_node_or_null("WorldEnvironment") as WorldEnvironment
	if environment_node and environment_node.environment:
		environment_node.environment.ambient_light_energy = 0.14 if enabled else 0.28
		environment_node.environment.fog_density = 0.025 if enabled else 0.012


func _build_environment() -> void:
	var world_environment := WorldEnvironment.new()
	world_environment.name = "WorldEnvironment"
	var environment := Environment.new()
	environment.background_mode = Environment.BG_COLOR
	environment.background_color = Color("090d0d")
	environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	environment.ambient_light_color = Color("72817a")
	environment.ambient_light_energy = 0.28
	environment.reflected_light_source = Environment.REFLECTION_SOURCE_DISABLED
	environment.tonemap_mode = Environment.TONE_MAPPER_FILMIC
	environment.fog_enabled = true
	environment.fog_light_color = Color("32413f")
	environment.fog_light_energy = 0.45
	environment.fog_density = 0.012
	environment.fog_height = 0.0
	environment.fog_height_density = 0.18
	world_environment.environment = environment
	_scene_parent().add_child(world_environment)

	var moon := DirectionalLight3D.new()
	moon.rotation_degrees = Vector3(-55, -25, 0)
	moon.light_color = Color("819aa4")
	moon.light_energy = 0.42
	moon.shadow_enabled = false
	_scene_parent().add_child(moon)


func _build_exterior() -> void:
	_static_box("Street", Vector3(0, -0.16, 21), Vector3(24, 0.3, 18), _material(Color("252a29"), 0.97))
	for index in range(11):
		_box(self, "Paving", Vector3(-5 + index, 0.01, 15.5), Vector3(0.92, 0.04, 5.8), _material(Color("404744") if index % 2 == 0 else Color("303634"), 0.94))
	_static_box("FacadeLeft", Vector3(-4.1, 3.2, 12), Vector3(5.7, 6.4, 0.55), _material(Color("34443f"), 0.9))
	_static_box("FacadeRight", Vector3(4.1, 3.2, 12), Vector3(5.7, 6.4, 0.55), _material(Color("34443f"), 0.9))
	_static_box("FacadeLintel", Vector3(0, 5.1, 12), Vector3(2.5, 2.6, 0.55), _material(Color("34443f"), 0.9))
	for x in [-4.7, 4.7]:
		_box(self, "FacadeColumn", Vector3(x, 3.2, 12.35), Vector3(0.48, 6.2, 0.48), _material(Color("17241f"), 0.8))
		_box(self, "ColumnBase", Vector3(x, 0.35, 12.38), Vector3(0.7, 0.7, 0.7), _material(Color("736a54"), 0.92))
	_static_box("FrontDoor", Vector3(0, 1.65, 12.18), Vector3(2.4, 3.3, 0.24), _material(wood, 0.72))
	for x in [-0.72, 0.72]:
		_box(self, "DoorPanel", Vector3(x, 1.65, 12.04), Vector3(0.82, 2.55, 0.08), _material(Color("1a1210"), 0.68))
		_cylinder(self, "DoorHandle", Vector3(x * 0.35, 1.55, 11.95), 0.06, 0.15, _metal(brass), Vector3(90, 0, 0))
	_interaction("front_door", "进入梁宅", Vector3(0, 1.5, 12.0), Vector3(2.5, 3.0, 0.8))
	_sign(Vector3(0, 4.05, 11.68), "LEONG HOUSE\n梁宅", Color("d4bc76"), 34)
	_light(Vector3(0, 3.5, 14), Color("e4bb70"), 2.6, 9.0)
	_build_rain(Vector3(0, 5.0, 20), Vector3(10, 0.5, 8))


func _build_front_hall() -> void:
	_static_box("HallFloor", Vector3(0, -0.14, 5), Vector3(12, 0.28, 14), _material(Color("1d2422"), 0.88))
	_build_tile_field(Vector3(0, 0.01, 5), 8, 10, 1.15)
	_static_box("HallLeftWall", Vector3(-6, 2.75, 5), Vector3(0.34, 5.5, 14), _wall_material())
	_static_box("HallRightWall", Vector3(6, 2.75, 5), Vector3(0.34, 5.5, 14), _wall_material())
	_static_box("HallCeiling", Vector3(0, 5.45, 5), Vector3(12, 0.25, 14), _material(Color("2d302b"), 0.93))
	_static_box("HallBackLeft", Vector3(-4.3, 2.75, -2), Vector3(3.4, 5.5, 0.34), _wall_material())
	_static_box("HallBackRight", Vector3(4.3, 2.75, -2), Vector3(3.4, 5.5, 0.34), _wall_material())
	_static_box("HallBackLintel", Vector3(0, 4.65, -2), Vector3(5.2, 1.6, 0.34), _wall_material())
	_static_box("HallCourtyardDoor", Vector3(0, 1.8, -1.93), Vector3(5.0, 3.6, 0.22), _material(wood, 0.72))
	for x in [-1.25, 1.25]:
		_box(self, "CourtyardDoorPanel", Vector3(x, 1.8, -1.80), Vector3(2.2, 3.1, 0.08), _material(Color("1a1210"), 0.7))
	for x in [-5.75, 5.75]:
		_box(self, "Wainscot", Vector3(x * 0.99, 1.0, 5), Vector3(0.16, 2.0, 13.5), _material(wood_highlight, 0.74))
		for z in range(0, 5):
			_box(self, "WallTrim", Vector3(x * 0.975, 1.25, 0.2 + z * 2.6), Vector3(0.1, 1.45, 1.9), _material(brass.darkened(0.45), 0.68))

	_build_chandelier(Vector3(0, 4.45, 5.7))
	_build_blackwood_chair(Vector3(-4.55, 0, 7.7), 90)
	_build_blackwood_chair(Vector3(-4.55, 0, 5.8), 90)
	_build_blackwood_chair(Vector3(4.55, 0, 7.7), -90)
	_build_blackwood_chair(Vector3(4.55, 0, 5.8), -90)
	_build_display_cabinet(Vector3(4.85, 0, 1.0), -90)
	_build_console_table(Vector3(-4.7, 0, 1.3), 90)

	family_photo = _textured_quad("LeongFamilyPhoto", Vector3(-4.25, 3.15, -1.78), Vector2(3.15, 2.35), FAMILY_TEXTURE)
	yuecheng_photo = _textured_quad("YuechengPhoto", Vector3(-4.25, 3.15, -1.76), Vector2(1.8, 2.45), YUECHENG_TEXTURE)
	yuecheng_photo.visible = false
	_build_picture_frame(Vector3(-4.25, 3.15, -1.70), Vector2(3.4, 2.7))
	_interaction("exhibit_photo", "查看梁氏家族合照", Vector3(-4.25, 2.7, -1.25), Vector3(3.5, 3.2, 1.0))

	_build_porcelain(Vector3(4.78, 1.18, 1.0))
	_interaction("exhibit_porcelain", "扫描青花盖罐展签", Vector3(4.7, 1.4, 1.0), Vector3(1.4, 2.2, 1.4))
	_interaction("exhibit_chair", "扫描黑木太师椅展签", Vector3(-4.5, 1.0, 6.8), Vector3(1.5, 2.2, 3.2))
	_build_grandfather_clock(Vector3(-4.85, 0, 10.3))
	_interaction("exhibit_clock", "扫描停在 19:19 的座钟", Vector3(-4.7, 1.8, 10.2), Vector3(1.5, 3.8, 1.3))
	_build_letter_case(Vector3(4.7, 0, 9.9))
	_interaction("exhibit_letter", "扫描新嘉坡来信", Vector3(4.6, 1.2, 9.8), Vector3(1.8, 2.4, 1.4))
	_interaction("courtyard_gate", "走进天井", Vector3(0, 1.55, -1.55), Vector3(4.6, 3.1, 0.5))
	for light_position in [Vector3(-3.8, 3.4, 2.0), Vector3(3.8, 3.4, 2.0), Vector3(0, 4.5, 8.5)]:
		exhibit_lights.append(_light(light_position, Color("e2b96d"), 2.25, 7.0))


func _build_courtyard() -> void:
	_static_box("CourtyardFloor", Vector3(0, -0.13, -6), Vector3(12, 0.26, 8), _material(Color("283331"), 0.98))
	_build_tile_field(Vector3(0, 0.01, -6), 8, 6, 1.15)
	_static_box("CourtyardLeft", Vector3(-6, 2.8, -6), Vector3(0.34, 5.6, 8), _wall_material())
	_static_box("CourtyardRight", Vector3(6, 2.8, -6), Vector3(0.34, 5.6, 8), _wall_material())
	_static_box("CourtyardBackLeft", Vector3(-4.3, 2.8, -10), Vector3(3.4, 5.6, 0.34), _wall_material())
	_static_box("CourtyardBackRight", Vector3(4.3, 2.8, -10), Vector3(3.4, 5.6, 0.34), _wall_material())
	_static_box("CourtyardBackLintel", Vector3(0, 4.7, -10), Vector3(5.2, 1.8, 0.34), _wall_material())
	_static_box("CourtyardBackDoors", Vector3(0, 1.75, -9.93), Vector3(5.0, 3.5, 0.22), _material(wood, 0.72))
	for x in [-1.3, 1.3]:
		_box(self, "BackDoorPanel", Vector3(x, 1.75, -9.80), Vector3(2.25, 3.0, 0.08), _material(Color("1a1210"), 0.7))
	_build_well(Vector3(0, 0, -6.2))
	_build_staircase(Vector3(4.8, 0, -8.0))
	_build_rain(Vector3(0, 5.4, -6), Vector3(5.5, 0.4, 3.7))
	for x in [-5.4, 5.4]:
		_box(self, "CoveredWalk", Vector3(x, 4.25, -6), Vector3(1.1, 0.18, 8), _material(Color("1c1815"), 0.84))
		for z in [-9.1, -6.0, -2.9]:
			_cylinder(self, "CourtyardPost", Vector3(x, 2.1, z), 0.13, 4.2, _material(wood, 0.75))
	_light(Vector3(0, 4.4, -6), Color("7394a2"), 1.6, 11.0)
	_interaction("door_beadwork", "进入珠绣房", Vector3(-6.0, 1.5, -5.1), Vector3(0.9, 3.0, 2.4))
	_interaction("door_kitchen", "进入娘惹厨房", Vector3(6.0, 1.5, -5.1), Vector3(0.9, 3.0, 2.4))
	_interaction("door_office", "进入账房", Vector3(-1.3, 1.5, -9.55), Vector3(2.3, 3.0, 0.5))
	_interaction("door_ancestor", "进入祖先厅", Vector3(1.3, 1.5, -9.55), Vector3(2.3, 3.0, 0.5))


func _build_beadwork_room() -> void:
	_build_room_shell("Bead", Vector3(-11, 0, -6), Vector2(8, 8), Color("4d3344"))
	_build_vanity(Vector3(-13.5, 0, -8.7))
	_build_folding_screen(Vector3(-8.8, 0, -8.8))
	_build_dress_stand(Vector3(-13.4, 0, -3.4))
	_build_beaded_shoes(Vector3(-10.5, 0.92, -5.8))
	_box(self, "BeadTable", Vector3(-10.5, 0.72, -5.8), Vector3(2.8, 0.18, 1.5), _material(wood_highlight, 0.72))
	for leg_x in [-11.6, -9.4]:
		for leg_z in [-6.3, -5.3]:
			_box(self, "BeadTableLeg", Vector3(leg_x, 0.35, leg_z), Vector3(0.16, 0.7, 0.16), _material(wood, 0.76))
	var motifs := [
		["motif_phoenix", "查看凤凰珠样", Vector3(-11.35, 1.18, -5.75), Color("b1684b")],
		["motif_peony", "查看牡丹珠样", Vector3(-10.78, 1.18, -5.75), Color("a24558")],
		["motif_butterfly", "查看蝴蝶珠样", Vector3(-10.20, 1.18, -5.75), Color("4f7f79")],
		["motif_pomegranate", "查看石榴珠样", Vector3(-9.63, 1.18, -5.75), Color("8d5435")],
	]
	for motif in motifs:
		_sphere(self, "BeadMotif", motif[2], 0.13, _emissive(motif[3], 0.8), Vector3(1, 0.3, 1))
		_interaction(motif[0], motif[1], motif[2], Vector3(0.45, 0.45, 0.45))
	_interaction("beaded_shoe", "检查未完成的珠绣鞋", Vector3(-10.5, 1.2, -5.8), Vector3(2.5, 1.0, 1.5))
	_interaction("bead_screen", "躲到屏风后", Vector3(-8.6, 1.3, -8.8), Vector3(1.2, 2.6, 2.8))
	_interaction("bead_return", "回到天井", Vector3(-7.0, 1.5, -5.1), Vector3(0.8, 3.0, 2.4))
	exhibit_lights.append(_light(Vector3(-10.5, 3.9, -5.8), Color("d99a83"), 2.6, 7.5))


func _build_kitchen() -> void:
	_build_room_shell("Kitchen", Vector3(11, 0, -6), Vector2(8, 8), Color("585446"))
	_static_box("KitchenCounter", Vector3(13.3, 0.65, -8.8), Vector3(3.8, 1.3, 1.0), _material(Color("453428"), 0.88))
	_build_stove(Vector3(13.5, 0, -8.4))
	_build_tok_panjang(Vector3(10.7, 0, -5.5))
	_build_kitchen_shelves(Vector3(13.8, 0, -3.1))
	_build_spice_jars(Vector3(13.2, 1.45, -8.7))
	var seats := [
		["seat_liang_ruiting", Vector3(10.7, 0.95, -7.35)],
		["seat_chen_youde", Vector3(12.1, 0.95, -6.55)],
		["seat_he_meizhu", Vector3(12.1, 0.95, -5.5)],
		["seat_liang_yuecheng", Vector3(12.1, 0.95, -4.45)],
		["seat_liang_qiwen", Vector3(9.3, 0.95, -4.45)],
		["seat_achun", Vector3(9.3, 0.95, -5.5)],
	]
	for seat in seats:
		_cylinder(self, "PlaceBowl", seat[1], 0.22, 0.13, _material(porcelain, 0.34))
		_interaction(seat[0], "摆放这一席的碗筷", seat[1], Vector3(0.75, 0.7, 0.75))
	_interaction("kitchen_recipe", "阅读 Ayam Pongteh 食谱", Vector3(13.2, 1.75, -8.4), Vector3(2.0, 1.6, 1.4))
	_interaction("kitchen_return", "回到天井", Vector3(7.0, 1.5, -5.1), Vector3(0.8, 3.0, 2.4))
	exhibit_lights.append(_light(Vector3(11, 3.8, -5.8), Color("ee9a4f"), 3.0, 8.5))


func _build_office() -> void:
	_build_room_shell("Office", Vector3(-6, 0, -15), Vector2(8, 8), Color("343c36"))
	_build_office_desk(Vector3(-6, 0, -16))
	_build_ledger_stack(Vector3(-6.9, 1.2, -15.9), burgundy)
	_build_ledger_stack(Vector3(-6.0, 1.2, -15.9), jade)
	_build_ledger_stack(Vector3(-5.1, 1.2, -15.9), Color("806740"))
	_build_abacus(Vector3(-6, 1.25, -15.15))
	_build_rubber_contracts(Vector3(-8.8, 0, -17.8))
	_interaction("ledger_home", "比对梁宅家账", Vector3(-6.9, 1.35, -15.9), Vector3(0.8, 0.7, 0.9))
	_interaction("ledger_shipping", "比对橡胶货账", Vector3(-6.0, 1.35, -15.9), Vector3(0.8, 0.7, 0.9))
	_interaction("ledger_pharmacy", "比对药房账", Vector3(-5.1, 1.35, -15.9), Vector3(0.8, 0.7, 0.9))
	_interaction("office_abacus", "查看自动拨动的算盘", Vector3(-6, 1.35, -15.1), Vector3(2.2, 0.8, 0.9))
	_interaction("office_return", "回到天井", Vector3(-4.0, 1.5, -11.0), Vector3(2.0, 3.0, 0.8))
	exhibit_lights.append(_light(Vector3(-6, 3.7, -15.5), Color("8db48c"), 2.2, 7.0))


func _build_ancestor_hall() -> void:
	_build_room_shell("Ancestor", Vector3(3, 0, -16), Vector2(10, 10), Color("36242a"))
	_build_altar(Vector3(3, 0, -20.1))
	for index in range(7):
		var x := 0.2 + index * 0.92
		_build_ancestor_tablet(Vector3(x, 1.65 + (index % 2) * 0.25, -20.0), index)
	for x in [0.4, 5.6]:
		_build_candle(Vector3(x, 1.25, -19.65))
	_build_evidence_case(Vector3(3, 0, -16.2))
	_interaction("ancestor_case", "把证据放入最后展柜", Vector3(3, 1.2, -16.2), Vector3(3.6, 2.4, 2.0))
	_interaction("ancestor_terminal", "生成梁月澄的最后展签", Vector3(3, 1.7, -19.6), Vector3(4.0, 3.0, 1.2))
	_interaction("ancestor_return", "回到天井", Vector3(1.0, 1.5, -11.0), Vector3(2.0, 3.0, 0.8))
	exhibit_lights.append(_light(Vector3(3, 3.8, -17), Color("d57a56"), 2.4, 8.0))


func _build_room_shell(prefix: String, center: Vector3, size: Vector2, upper_color: Color) -> void:
	_static_box(prefix + "Floor", center + Vector3(0, -0.14, 0), Vector3(size.x, 0.28, size.y), _material(Color("251d19"), 0.9))
	_static_box(prefix + "Ceiling", center + Vector3(0, 4.8, 0), Vector3(size.x, 0.22, size.y), _material(Color("25241f"), 0.94))
	_static_box(prefix + "North", center + Vector3(0, 2.4, -size.y * 0.5), Vector3(size.x, 4.8, 0.3), _material(upper_color, 0.9))
	_static_box(prefix + "South", center + Vector3(0, 2.4, size.y * 0.5), Vector3(size.x, 4.8, 0.3), _material(upper_color, 0.9))
	_static_box(prefix + "East", center + Vector3(size.x * 0.5, 2.4, 0), Vector3(0.3, 4.8, size.y), _material(upper_color, 0.9))
	_static_box(prefix + "West", center + Vector3(-size.x * 0.5, 2.4, 0), Vector3(0.3, 4.8, size.y), _material(upper_color, 0.9))
	for wall_z in [-size.y * 0.5 + 0.18, size.y * 0.5 - 0.18]:
		_box(self, prefix + "Wainscot", center + Vector3(0, 0.9, wall_z), Vector3(size.x - 0.5, 1.8, 0.12), _material(wood_highlight, 0.72))


func _build_tile_field(center: Vector3, columns: int, rows: int, tile_size: float) -> void:
	var transforms_a: Array[Transform3D] = []
	var transforms_b: Array[Transform3D] = []
	for x_index in range(columns):
		for z_index in range(rows):
			var x := (x_index - (columns - 1) * 0.5) * tile_size
			var z := (z_index - (rows - 1) * 0.5) * tile_size
			var transform := Transform3D(Basis.IDENTITY, center + Vector3(x, 0, z))
			if (x_index + z_index) % 2 == 0:
				transforms_a.append(transform)
			else:
				transforms_b.append(transform)
	_build_tile_multimesh("JadePatternTiles", transforms_a, tile_size, Color("274b48"))
	_build_tile_multimesh("IvoryPatternTiles", transforms_b, tile_size, Color("968760"))


func _build_tile_multimesh(node_name: String, transforms: Array[Transform3D], tile_size: float, color: Color) -> void:
	var mesh := BoxMesh.new()
	mesh.size = Vector3(tile_size * 0.94, 0.035, tile_size * 0.94)
	mesh.material = _material(color, 0.86)
	var multimesh := MultiMesh.new()
	multimesh.transform_format = MultiMesh.TRANSFORM_3D
	multimesh.mesh = mesh
	multimesh.instance_count = transforms.size()
	for index in range(transforms.size()):
		multimesh.set_instance_transform(index, transforms[index])
	var instance := MultiMeshInstance3D.new()
	instance.name = node_name
	instance.multimesh = multimesh
	_scene_parent().add_child(instance)

func _build_chandelier(position_value: Vector3) -> void:
	_cylinder(self, "ChandelierStem", position_value, 0.055, 1.35, _metal(brass))
	_cylinder(self, "ChandelierRing", position_value + Vector3(0, -0.55, 0), 0.62, 0.08, _metal(brass))
	for index in range(8):
		var angle := TAU * index / 8.0
		var bulb_position := position_value + Vector3(cos(angle) * 0.62, -0.45, sin(angle) * 0.62)
		_sphere(self, "ChandelierBulb", bulb_position, 0.09, _emissive(Color("ffd98c"), 2.0))


func _build_blackwood_chair(position_value: Vector3, yaw: float) -> void:
	var chair := Node3D.new()
	chair.position = position_value
	chair.rotation_degrees.y = yaw
	_scene_parent().add_child(chair)
	_box(chair, "Seat", Vector3(0, 0.62, 0), Vector3(1.0, 0.14, 0.9), _material(wood, 0.68))
	_box(chair, "Back", Vector3(0, 1.35, 0.38), Vector3(1.05, 1.45, 0.15), _material(wood, 0.68))
	for x in [-0.4, 0.4]:
		for z in [-0.32, 0.32]:
			_box(chair, "ChairLeg", Vector3(x, 0.3, z), Vector3(0.13, 0.6, 0.13), _material(wood, 0.7))
		_box(chair, "Arm", Vector3(x * 1.15, 0.95, 0), Vector3(0.12, 0.12, 0.92), _material(wood_highlight, 0.7))


func _build_display_cabinet(position_value: Vector3, yaw: float) -> void:
	var cabinet := Node3D.new()
	cabinet.position = position_value
	cabinet.rotation_degrees.y = yaw
	_scene_parent().add_child(cabinet)
	_box(cabinet, "Cabinet", Vector3.ZERO, Vector3(1.5, 2.5, 0.72), _material(wood, 0.66))
	_box(cabinet, "CabinetGlass", Vector3(0, 0.35, -0.38), Vector3(1.2, 1.5, 0.04), _glass_material(Color("9db8b4"), 0.22))
	for y in [-0.25, 0.45, 1.1]:
		_box(cabinet, "Shelf", Vector3(0, y, -0.15), Vector3(1.25, 0.06, 0.5), _material(wood_highlight, 0.74))


func _build_console_table(position_value: Vector3, yaw: float) -> void:
	var table := Node3D.new()
	table.position = position_value
	table.rotation_degrees.y = yaw
	_scene_parent().add_child(table)
	_box(table, "Top", Vector3(0, 0.92, 0), Vector3(2.7, 0.16, 0.72), _material(wood_highlight, 0.65))
	for x in [-1.15, 1.15]:
		_box(table, "Leg", Vector3(x, 0.45, 0), Vector3(0.16, 0.9, 0.16), _material(wood, 0.7))


func _build_porcelain(position_value: Vector3) -> void:
	_cylinder(self, "PorcelainJar", position_value, 0.28, 0.72, _material(porcelain, 0.3))
	_cylinder(self, "PorcelainLid", position_value + Vector3(0, 0.42, 0), 0.2, 0.12, _material(Color("315d69"), 0.3))
	for angle in range(0, 360, 60):
		var radians := deg_to_rad(angle)
		_sphere(self, "BluePattern", position_value + Vector3(cos(radians) * 0.285, 0.05, sin(radians) * 0.285), 0.045, _material(Color("315d69"), 0.35))


func _build_grandfather_clock(position_value: Vector3) -> void:
	_box(self, "ClockBody", position_value + Vector3(0, 1.5, 0), Vector3(0.85, 3.0, 0.52), _material(wood, 0.67))
	_cylinder(self, "ClockFace", position_value + Vector3(0, 2.35, -0.29), 0.3, 0.06, _material(Color("d5c89f"), 0.4), Vector3(90, 0, 0))
	_cylinder(self, "ClockPendulum", position_value + Vector3(0, 1.15, -0.29), 0.15, 0.06, _metal(brass), Vector3(90, 0, 0))
	_box(self, "PendulumRod", position_value + Vector3(0, 1.5, -0.29), Vector3(0.035, 0.72, 0.035), _metal(brass))


func _build_letter_case(position_value: Vector3) -> void:
	_box(self, "LetterStand", position_value + Vector3(0, 0.72, 0), Vector3(1.6, 1.44, 0.8), _material(wood, 0.7))
	var paper := _material(Color("d8c89f"), 0.96)
	_box(self, "SingaporeLetter", position_value + Vector3(0, 1.48, -0.08), Vector3(1.1, 0.035, 0.7), paper)


func _build_well(position_value: Vector3) -> void:
	_cylinder(self, "WellStone", position_value + Vector3(0, 0.42, 0), 0.92, 0.84, _material(Color("5e655e"), 0.98))
	_cylinder(self, "WellWater", position_value + Vector3(0, 0.86, 0), 0.68, 0.04, _material(Color("101c1d"), 0.22))
	for x in [-0.95, 0.95]:
		_box(self, "WellPost", position_value + Vector3(x, 1.55, 0), Vector3(0.16, 2.6, 0.16), _material(wood, 0.78))
	_box(self, "WellBeam", position_value + Vector3(0, 2.75, 0), Vector3(2.2, 0.18, 0.18), _material(wood, 0.78))


func _build_staircase(position_value: Vector3) -> void:
	for index in range(7):
		_box(self, "Stair", position_value + Vector3(0, index * 0.28, index * 0.42), Vector3(1.6, 0.28, 0.55), _material(wood_highlight, 0.8))


func _build_vanity(position_value: Vector3) -> void:
	_box(self, "Vanity", position_value + Vector3(0, 0.72, 0), Vector3(2.0, 1.44, 0.7), _material(wood_highlight, 0.7))
	_box(self, "MirrorFrame", position_value + Vector3(0, 2.15, 0.15), Vector3(1.65, 1.6, 0.12), _metal(brass))
	_box(self, "Mirror", position_value + Vector3(0, 2.15, 0.08), Vector3(1.38, 1.34, 0.035), _material(Color("7d8f8c"), 0.12))


func _build_folding_screen(position_value: Vector3) -> void:
	for index in range(3):
		var panel := Node3D.new()
		panel.position = position_value + Vector3(index * 0.82, 1.35, 0)
		panel.rotation_degrees.y = -12 + index * 12
		add_child(panel)
		_box(panel, "ScreenFrame", Vector3.ZERO, Vector3(0.78, 2.7, 0.12), _material(wood, 0.68))
		_box(panel, "ScreenSilk", Vector3(0, 0, -0.07), Vector3(0.62, 2.45, 0.03), _material(Color("90735d"), 0.9))


func _build_dress_stand(position_value: Vector3) -> void:
	_cylinder(self, "DressStand", position_value + Vector3(0, 1.2, 0), 0.08, 2.4, _material(wood, 0.75))
	_box(self, "Kebaya", position_value + Vector3(0, 1.7, 0), Vector3(0.9, 1.2, 0.18), _material(Color("5b7b70"), 0.88))
	_cylinder(self, "DressBase", position_value + Vector3(0, 0.08, 0), 0.48, 0.12, _material(wood_highlight, 0.76))


func _build_beaded_shoes(position_value: Vector3) -> void:
	for x in [-0.42, 0.42]:
		_box(self, "BeadedShoe", position_value + Vector3(x, 0, 0), Vector3(0.54, 0.18, 0.82), _material(Color("b06e62"), 0.54))
		for bead_index in range(6):
			_sphere(self, "ShoeBead", position_value + Vector3(x - 0.15 + (bead_index % 3) * 0.15, 0.11, -0.15 + (bead_index / 3) * 0.18), 0.035, _emissive(Color("e0c57f"), 0.45))


func _build_stove(position_value: Vector3) -> void:
	_box(self, "Stove", position_value + Vector3(0, 0.55, 0), Vector3(1.6, 1.1, 1.0), _material(Color("252423"), 0.94))
	_cylinder(self, "CookingPot", position_value + Vector3(0, 1.28, 0), 0.52, 0.54, _metal(Color("4d4944")))
	_sphere(self, "FireGlow", position_value + Vector3(0, 0.5, -0.52), 0.22, _emissive(Color("ff7638"), 2.2), Vector3(1.8, 0.65, 0.45))


func _build_tok_panjang(position_value: Vector3) -> void:
	_box(self, "TokPanjangTop", position_value + Vector3(0, 0.82, 0), Vector3(3.2, 0.18, 1.45), _material(wood_highlight, 0.7))
	for x in [-1.35, 1.35]:
		for z in [-0.55, 0.55]:
			_box(self, "TokPanjangLeg", position_value + Vector3(x, 0.4, z), Vector3(0.16, 0.8, 0.16), _material(wood, 0.75))


func _build_kitchen_shelves(position_value: Vector3) -> void:
	for y in [0.8, 1.55, 2.3]:
		_box(self, "KitchenShelf", position_value + Vector3(0, y, 0), Vector3(2.2, 0.12, 0.65), _material(wood_highlight, 0.76))
		for x in [-0.75, -0.25, 0.25, 0.75]:
			_cylinder(self, "KitchenBowl", position_value + Vector3(x, y + 0.16, 0), 0.16, 0.12, _material(porcelain, 0.38))


func _build_spice_jars(position_value: Vector3) -> void:
	for index in range(6):
		var x := (index - 2.5) * 0.42
		_cylinder(self, "SpiceJar", position_value + Vector3(x, 0, 0), 0.16, 0.45, _material(Color("8a7457").lightened(index * 0.025), 0.8))


func _build_office_desk(position_value: Vector3) -> void:
	_static_box("OfficeDesk", position_value + Vector3(0, 0.75, 0), Vector3(3.5, 1.5, 1.5), _material(wood_highlight, 0.68))
	_box(self, "DeskLeather", position_value + Vector3(0, 1.53, -0.05), Vector3(2.5, 0.04, 0.9), _material(Color("344b3c"), 0.76))


func _build_ledger_stack(position_value: Vector3, color: Color) -> void:
	for index in range(3):
		_box(self, "Ledger", position_value + Vector3(0, index * 0.1, 0), Vector3(0.72, 0.08, 0.92), _material(color.darkened(index * 0.08), 0.88))


func _build_abacus(position_value: Vector3) -> void:
	_box(self, "AbacusFrame", position_value, Vector3(1.8, 0.12, 0.7), _material(wood, 0.68))
	for row in range(5):
		_box(self, "AbacusRod", position_value + Vector3(0, 0.08, -0.24 + row * 0.12), Vector3(1.5, 0.035, 0.035), _metal(brass))
		for bead in range(7):
			_sphere(self, "AbacusBead", position_value + Vector3(-0.62 + bead * 0.2, 0.11, -0.24 + row * 0.12), 0.055, _material(burgundy, 0.6), Vector3(1.5, 0.6, 0.8))


func _build_rubber_contracts(position_value: Vector3) -> void:
	_box(self, "ContractCabinet", position_value + Vector3(0, 1.0, 0), Vector3(1.4, 2.0, 0.6), _material(wood, 0.7))
	for index in range(6):
		_box(self, "ContractDrawer", position_value + Vector3(0, 0.35 + index * 0.26, -0.33), Vector3(1.1, 0.19, 0.08), _material(wood_highlight, 0.72))


func _build_altar(position_value: Vector3) -> void:
	_box(self, "AltarTop", position_value + Vector3(0, 1.1, 0), Vector3(5.4, 0.2, 1.3), _material(wood_highlight, 0.62))
	_box(self, "AltarBack", position_value + Vector3(0, 2.15, 0.45), Vector3(5.4, 2.1, 0.2), _material(wood, 0.64))
	for x in [-2.35, 2.35]:
		_box(self, "AltarLeg", position_value + Vector3(x, 0.55, 0), Vector3(0.24, 1.1, 0.7), _material(wood, 0.68))


func _build_ancestor_tablet(position_value: Vector3, index: int) -> void:
	_box(self, "AncestorTablet", position_value, Vector3(0.48, 1.05, 0.16), _material(Color("261416"), 0.6))
	_box(self, "TabletMark", position_value + Vector3(0, 0.05, -0.1), Vector3(0.045, 0.62, 0.025), _emissive(Color("c4a45a"), 0.35 + index * 0.03))
	_box(self, "TabletBase", position_value + Vector3(0, -0.58, 0), Vector3(0.72, 0.16, 0.42), _material(wood_highlight, 0.65))


func _build_candle(position_value: Vector3) -> void:
	_cylinder(self, "Candle", position_value, 0.09, 0.65, _material(Color("ddd0a7"), 0.92))
	_sphere(self, "CandleFlame", position_value + Vector3(0, 0.4, 0), 0.065, _emissive(Color("ff9e52"), 2.5), Vector3(0.7, 1.7, 0.7))


func _build_evidence_case(position_value: Vector3) -> void:
	_box(self, "CaseBase", position_value + Vector3(0, 0.55, 0), Vector3(3.0, 1.1, 1.5), _material(wood, 0.68))
	_box(self, "CaseGlass", position_value + Vector3(0, 1.45, 0), Vector3(2.8, 0.9, 1.35), _glass_material(Color("9cb7b2"), 0.18))
	_box(self, "CasePlinth", position_value + Vector3(0, 1.02, 0), Vector3(2.7, 0.08, 1.25), _material(Color("b5a27a"), 0.9))


func _build_picture_frame(position_value: Vector3, size: Vector2) -> void:
	var thickness := 0.16
	_box(self, "FrameTop", position_value + Vector3(0, size.y * 0.5, 0), Vector3(size.x, thickness, 0.16), _metal(brass))
	_box(self, "FrameBottom", position_value + Vector3(0, -size.y * 0.5, 0), Vector3(size.x, thickness, 0.16), _metal(brass))
	_box(self, "FrameLeft", position_value + Vector3(-size.x * 0.5, 0, 0), Vector3(thickness, size.y, 0.16), _metal(brass))
	_box(self, "FrameRight", position_value + Vector3(size.x * 0.5, 0, 0), Vector3(thickness, size.y, 0.16), _metal(brass))


func _build_rain(position_value: Vector3, extents: Vector3) -> void:
	# CPU particles avoid an ANGLE driver hang on older Intel integrated graphics.
	var particles := CPUParticles3D.new()
	particles.position = position_value
	particles.amount = 140
	particles.lifetime = 1.4
	particles.emission_shape = CPUParticles3D.EMISSION_SHAPE_BOX
	particles.emission_box_extents = extents
	particles.direction = Vector3(0, -1, 0)
	particles.spread = 2.0
	particles.initial_velocity_min = 7.5
	particles.initial_velocity_max = 10.0
	particles.gravity = Vector3(0, -6, 0)
	var drop := QuadMesh.new()
	drop.size = Vector2(0.018, 0.38)
	var drop_material := _emissive(Color("8ab0b5"), 0.25)
	drop_material.billboard_mode = BaseMaterial3D.BILLBOARD_ENABLED
	drop.material = drop_material
	particles.mesh = drop
	_scene_parent().add_child(particles)


func _wall_material() -> StandardMaterial3D:
	var key := "wallpaper"
	if material_cache.has(key):
		return material_cache[key]
	var material := StandardMaterial3D.new()
	material.albedo_color = Color.WHITE
	material.roughness = 0.92
	material.albedo_texture = WALLPAPER_TEXTURE
	material.uv1_scale = Vector3(2.5, 1.4, 2.5)
	material_cache[key] = material
	return material

func _textured_quad(node_name: String, position_value: Vector3, size: Vector2, texture: Texture2D) -> MeshInstance3D:
	var mesh_instance := MeshInstance3D.new()
	mesh_instance.name = node_name
	mesh_instance.position = position_value
	var quad := QuadMesh.new()
	quad.size = size
	var material := StandardMaterial3D.new()
	material.albedo_texture = texture
	material.roughness = 0.84
	quad.material = material
	mesh_instance.mesh = quad
	_scene_parent().add_child(mesh_instance)
	return mesh_instance


func _static_box(node_name: String, position_value: Vector3, size: Vector3, material: Material) -> StaticBody3D:
	var body := StaticBody3D.new()
	body.name = node_name
	body.position = position_value
	body.collision_layer = 1
	body.collision_mask = 1
	_scene_parent().add_child(body)
	var mesh_instance := MeshInstance3D.new()
	var mesh := BoxMesh.new()
	mesh.size = size
	mesh_instance.mesh = mesh
	mesh_instance.material_override = material
	body.add_child(mesh_instance)
	var collider := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = size
	collider.shape = shape
	body.add_child(collider)
	return body


func _interaction(interaction_id: String, prompt: String, position_value: Vector3, size: Vector3) -> Area3D:
	var area := Area3D.new()
	area.name = "Interact_" + interaction_id
	area.position = position_value
	area.collision_layer = 2
	area.collision_mask = 0
	area.set_meta("interaction_id", interaction_id)
	area.set_meta("prompt", prompt)
	var collider := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = size
	collider.shape = shape
	area.add_child(collider)
	_scene_parent().add_child(area)
	return area


func _box(parent: Node3D, node_name: String, position_value: Vector3, size: Vector3, material: Material) -> MeshInstance3D:
	var mesh_instance := MeshInstance3D.new()
	mesh_instance.name = node_name
	mesh_instance.position = position_value
	var mesh := BoxMesh.new()
	mesh.size = size
	mesh_instance.mesh = mesh
	mesh_instance.material_override = material
	_resolve_parent(parent).add_child(mesh_instance)
	return mesh_instance


func _cylinder(parent: Node3D, node_name: String, position_value: Vector3, radius: float, height: float, material: Material, rotation_value: Vector3 = Vector3.ZERO) -> MeshInstance3D:
	var mesh_instance := MeshInstance3D.new()
	mesh_instance.name = node_name
	mesh_instance.position = position_value
	mesh_instance.rotation_degrees = rotation_value
	var mesh := CylinderMesh.new()
	mesh.top_radius = radius
	mesh.bottom_radius = radius
	mesh.height = height
	mesh_instance.mesh = mesh
	mesh_instance.material_override = material
	_resolve_parent(parent).add_child(mesh_instance)
	return mesh_instance


func _sphere(parent: Node3D, node_name: String, position_value: Vector3, radius: float, material: Material, scale_value: Vector3 = Vector3.ONE) -> MeshInstance3D:
	var mesh_instance := MeshInstance3D.new()
	mesh_instance.name = node_name
	mesh_instance.position = position_value
	mesh_instance.scale = scale_value
	var mesh := SphereMesh.new()
	mesh.radius = radius
	mesh.height = radius * 2.0
	mesh_instance.mesh = mesh
	mesh_instance.material_override = material
	_resolve_parent(parent).add_child(mesh_instance)
	return mesh_instance


func _sign(position_value: Vector3, text_value: String, color: Color, font_size: int) -> void:
	var label := Label3D.new()
	label.position = position_value
	label.text = text_value
	label.font_size = font_size
	label.outline_size = 10
	label.modulate = color
	_scene_parent().add_child(label)


func _light(position_value: Vector3, color: Color, energy: float, range_value: float) -> OmniLight3D:
	var light := OmniLight3D.new()
	light.position = position_value
	light.light_color = color
	light.light_energy = 1.25 if night_mode else energy
	light.omni_range = range_value
	light.shadow_enabled = false
	_scene_parent().add_child(light)
	return light


func _material(color: Color, roughness: float) -> StandardMaterial3D:
	var key := "base_%s_%.3f" % [color.to_html(), roughness]
	if material_cache.has(key):
		return material_cache[key]
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	material.roughness = roughness
	material_cache[key] = material
	return material


func _metal(color: Color) -> StandardMaterial3D:
	var key := "metal_%s" % color.to_html()
	if material_cache.has(key):
		return material_cache[key]
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	material.roughness = 0.32
	material.metallic = 0.78
	material_cache[key] = material
	return material


func _emissive(color: Color, energy: float) -> StandardMaterial3D:
	var key := "emissive_%s_%.2f" % [color.to_html(), energy]
	if material_cache.has(key):
		return material_cache[key]
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	material.roughness = 0.45
	material.emission_enabled = true
	material.emission = color
	material.emission_energy_multiplier = energy
	material_cache[key] = material
	return material


func _glass_material(color: Color, alpha: float) -> StandardMaterial3D:
	var key := "glass_%s_%.2f" % [color.to_html(), alpha]
	if material_cache.has(key):
		return material_cache[key]
	var material := StandardMaterial3D.new()
	material.albedo_color = Color(color, alpha)
	material.roughness = 0.12
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	material.shading_mode = BaseMaterial3D.SHADING_MODE_PER_PIXEL
	material_cache[key] = material
	return material
