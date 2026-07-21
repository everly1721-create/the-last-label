extends Node3D

const PlayerController = preload("res://scripts/player_third_person.gd")
const HouseBuilder = preload("res://scripts/leong_house_builder_v3.gd")
const FAMILY_TEXTURE = preload("res://assets/textures/leong_family_1919.png")

const FRONT_EXHIBITS := {
	"exhibit_photo": "刮坏的梁氏家族合照",
	"exhibit_porcelain": "青花盖罐",
	"exhibit_chair": "黑木太师椅",
	"exhibit_clock": "停在 19:19 的座钟",
	"exhibit_letter": "新嘉坡来信",
}
const MOTIF_SOLUTION := ["motif_pomegranate", "motif_butterfly", "motif_phoenix", "motif_peony"]
const SEAT_SOLUTION := [
	"seat_liang_ruiting",
	"seat_chen_youde",
	"seat_he_meizhu",
	"seat_liang_yuecheng",
	"seat_liang_qiwen",
	"seat_achun",
]
const REQUIRED_EVIDENCE := ["刮坏的家族照片", "未完成的珠绣鞋", "油渍食谱", "药房账", "橡胶货运单"]

var level: Node3D
var player: CharacterBody3D
var shadow_actor: Node3D

var current_chapter := "序章"
var current_objective := "抵达梁宅"
var evidence: Array[String] = []
var front_scanned := {}
var motifs_read := {}
var motif_attempt: Array[String] = []
var recipe_views := 0
var seat_attempt: Array[String] = []
var ledgers_read := {}
var placed_evidence: Array[String] = []
var flags := {
	"front_complete": false,
	"bead_complete": false,
	"kitchen_complete": false,
	"office_complete": false,
	"chase_active": false,
	"game_started": false,
}

var title_overlay: Control
var objective_label: Label
var chapter_label: Label
var evidence_label: Label
var prompt_label: Label
var app_panel: PanelContainer
var app_label: Label
var app_timer := 0.0
var dialog_panel: PanelContainer
var dialog_title: Label
var dialog_body: RichTextLabel
var dialog_actions: GridContainer


func _ready() -> void:
	level = HouseBuilder.new()
	level.name = "LeongHouse"
	add_child(level)
	level.build()
	player = PlayerController.new()
	player.name = "XuAnning"
	player.position = Vector3(0, 0.05, 20)
	add_child(player)
	player.interaction_requested.connect(_handle_interaction)
	_build_shadow_actor()
	_build_ui()
	var preview := get_node_or_null("EditorPreviewLabel")
	if preview:
		preview.hide()
	_update_hud()
	_show_title_screen()
	if OS.get_cmdline_user_args().has("capture"):
		call_deferred("_capture_preview")


func _process(delta: float) -> void:
	_update_app_notification(delta)
	_update_shadow_chase(delta)
	if title_overlay.visible or dialog_panel.visible:
		prompt_label.visible = false
		return
	if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		prompt_label.text = "单击画面继续"
		prompt_label.visible = true
		return
	var target: Area3D = player.get_interaction_target()
	if target:
		prompt_label.text = "E  " + str(target.get_meta("prompt"))
		prompt_label.visible = true
	else:
		prompt_label.visible = false


func _build_ui() -> void:
	var canvas := CanvasLayer.new()
	canvas.name = "Interface"
	add_child(canvas)
	_build_vignette(canvas)

	var hud_panel := PanelContainer.new()
	hud_panel.position = Vector2(24, 22)
	hud_panel.size = Vector2(420, 118)
	hud_panel.add_theme_stylebox_override("panel", _panel_style(Color(0.015, 0.022, 0.021, 0.9), Color("806f4d"), 5))
	canvas.add_child(hud_panel)
	var hud_margin := _margin(17, 14)
	hud_panel.add_child(hud_margin)
	var hud_box := VBoxContainer.new()
	hud_box.add_theme_constant_override("separation", 4)
	hud_margin.add_child(hud_box)
	chapter_label = Label.new()
	chapter_label.add_theme_font_size_override("font_size", 14)
	chapter_label.add_theme_color_override("font_color", Color("b9a878"))
	hud_box.add_child(chapter_label)
	objective_label = Label.new()
	objective_label.add_theme_font_size_override("font_size", 19)
	objective_label.add_theme_color_override("font_color", Color("eee4cb"))
	objective_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	hud_box.add_child(objective_label)
	evidence_label = Label.new()
	evidence_label.add_theme_font_size_override("font_size", 14)
	evidence_label.add_theme_color_override("font_color", Color("8ba19b"))
	hud_box.add_child(evidence_label)

	app_panel = PanelContainer.new()
	app_panel.anchor_left = 1.0
	app_panel.anchor_right = 1.0
	app_panel.offset_left = -390
	app_panel.offset_right = -24
	app_panel.offset_top = 24
	app_panel.offset_bottom = 124
	app_panel.add_theme_stylebox_override("panel", _panel_style(Color(0.025, 0.055, 0.052, 0.96), Color("5c8981"), 6))
	canvas.add_child(app_panel)
	var app_margin := _margin(16, 13)
	app_panel.add_child(app_margin)
	app_label = Label.new()
	app_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	app_label.add_theme_font_size_override("font_size", 16)
	app_label.add_theme_color_override("font_color", Color("d6e8df"))
	app_margin.add_child(app_label)
	app_panel.visible = false

	var crosshair := Label.new()
	crosshair.text = "·"
	crosshair.add_theme_font_size_override("font_size", 30)
	crosshair.add_theme_color_override("font_color", Color(0.88, 0.82, 0.67, 0.75))
	crosshair.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	crosshair.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	crosshair.set_anchors_preset(Control.PRESET_CENTER)
	crosshair.position = Vector2(-12, -12)
	crosshair.size = Vector2(24, 24)
	canvas.add_child(crosshair)

	prompt_label = Label.new()
	prompt_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	prompt_label.add_theme_font_size_override("font_size", 18)
	prompt_label.add_theme_color_override("font_color", Color("f1e2b8"))
	prompt_label.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.95))
	prompt_label.add_theme_constant_override("shadow_offset_x", 2)
	prompt_label.add_theme_constant_override("shadow_offset_y", 2)
	prompt_label.anchor_left = 0.5
	prompt_label.anchor_right = 0.5
	prompt_label.anchor_top = 1.0
	prompt_label.anchor_bottom = 1.0
	prompt_label.offset_left = -340
	prompt_label.offset_right = 340
	prompt_label.offset_top = -76
	prompt_label.offset_bottom = -38
	canvas.add_child(prompt_label)

	dialog_panel = PanelContainer.new()
	dialog_panel.anchor_left = 0.13
	dialog_panel.anchor_right = 0.87
	dialog_panel.anchor_top = 0.54
	dialog_panel.anchor_bottom = 0.95
	dialog_panel.add_theme_stylebox_override("panel", _panel_style(Color(0.012, 0.016, 0.015, 0.97), Color("927b4e"), 6))
	canvas.add_child(dialog_panel)
	var dialog_margin := _margin(25, 18)
	dialog_panel.add_child(dialog_margin)
	var dialog_layout := VBoxContainer.new()
	dialog_layout.add_theme_constant_override("separation", 10)
	dialog_margin.add_child(dialog_layout)
	dialog_title = Label.new()
	dialog_title.add_theme_font_size_override("font_size", 23)
	dialog_title.add_theme_color_override("font_color", Color("e3cb8d"))
	dialog_layout.add_child(dialog_title)
	dialog_body = RichTextLabel.new()
	dialog_body.bbcode_enabled = true
	dialog_body.custom_minimum_size.y = 86
	dialog_body.size_flags_vertical = Control.SIZE_EXPAND_FILL
	dialog_body.add_theme_font_size_override("normal_font_size", 17)
	dialog_body.add_theme_font_size_override("bold_font_size", 17)
	dialog_body.add_theme_color_override("default_color", Color("ddd9ce"))
	dialog_layout.add_child(dialog_body)
	dialog_actions = GridContainer.new()
	dialog_actions.columns = 2
	dialog_actions.add_theme_constant_override("h_separation", 8)
	dialog_actions.add_theme_constant_override("v_separation", 7)
	dialog_layout.add_child(dialog_actions)
	dialog_panel.visible = false

	_build_title_overlay(canvas)


func _build_vignette(canvas: CanvasLayer) -> void:
	var overlay := ColorRect.new()
	overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var shader := Shader.new()
	shader.code = """
shader_type canvas_item;
void fragment() {
	vec2 uv = SCREEN_UV;
	float edge = smoothstep(0.28, 0.76, distance(uv, vec2(0.5)));
	COLOR = vec4(vec3(0.015, 0.025, 0.023), edge * 0.72);
}
"""
	var material := ShaderMaterial.new()
	material.shader = shader
	overlay.material = material
	canvas.add_child(overlay)


func _build_title_overlay(canvas: CanvasLayer) -> void:
	title_overlay = Control.new()
	title_overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	canvas.add_child(title_overlay)
	var backdrop := TextureRect.new()
	backdrop.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	backdrop.texture = FAMILY_TEXTURE
	backdrop.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	backdrop.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	backdrop.modulate = Color(0.28, 0.31, 0.28, 1)
	title_overlay.add_child(backdrop)
	var shade := ColorRect.new()
	shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	shade.color = Color(0.01, 0.02, 0.018, 0.55)
	title_overlay.add_child(shade)
	var title_box := VBoxContainer.new()
	title_box.anchor_left = 0.09
	title_box.anchor_right = 0.56
	title_box.anchor_top = 0.18
	title_box.anchor_bottom = 0.82
	title_box.add_theme_constant_override("separation", 13)
	title_overlay.add_child(title_box)
	var place := Label.new()
	place.text = "香兰港 · TANJONG SERAI"
	place.add_theme_font_size_override("font_size", 16)
	place.add_theme_color_override("font_color", Color("c4b98f"))
	title_box.add_child(place)
	var title := Label.new()
	title.text = "THE LAST LABEL\n最后的展签"
	title.add_theme_font_size_override("font_size", 46)
	title.add_theme_color_override("font_color", Color("f0e7ca"))
	title_box.add_child(title)
	var subtitle := Label.new()
	subtitle.text = "一段发生在虚构海峡祖屋梁宅的档案恐怖故事"
	subtitle.add_theme_font_size_override("font_size", 18)
	subtitle.add_theme_color_override("font_color", Color("b9c5bf"))
	title_box.add_child(subtitle)
	var spacer := Control.new()
	spacer.custom_minimum_size.y = 25
	title_box.add_child(spacer)
	var start_button := Button.new()
	start_button.text = "开始参观"
	start_button.custom_minimum_size = Vector2(260, 46)
	start_button.add_theme_font_size_override("font_size", 18)
	start_button.pressed.connect(_start_game)
	title_box.add_child(start_button)
	var quit_button := Button.new()
	quit_button.text = "退出"
	quit_button.custom_minimum_size = Vector2(260, 40)
	quit_button.pressed.connect(_quit_game)
	title_box.add_child(quit_button)


func _show_title_screen() -> void:
	title_overlay.visible = true
	dialog_panel.visible = false
	player.set_controls_enabled(false)


func _start_game() -> void:
	flags["game_started"] = true
	title_overlay.visible = false
	_opening_one()


func _opening_one() -> void:
	_show_dialog(
		"香兰港，下午四点十七分",
		"许安宁跟着旅行团来到[b]梁氏峇峇娘惹祖宅博物馆[/b]。雨落在骑楼外，纪念品店正在播放轻快的导览音乐。",
		[{"text": "领取手机导览任务", "action": _opening_two}]
	)


func _opening_two() -> void:
	_show_dialog(
		"梁宅导览 App",
		"今日任务：进入前厅，扫描五件展品。\n\n身后有游客在讨论晚餐，小孩踩着彩砖跑过。这里暂时只是一个普通博物馆。",
		[{"text": "开始参观", "action": _finish_opening}]
	)


func _finish_opening() -> void:
	current_chapter = "序章 · 雨中的梁宅"
	current_objective = "进入梁宅前厅"
	_close_dialog()
	_notify_app("梁宅导览已连接 · 展品任务 0/5")


func _handle_interaction(interaction_id: String) -> void:
	if FRONT_EXHIBITS.has(interaction_id):
		_scan_front_exhibit(interaction_id)
		return
	match interaction_id:
		"front_door": _enter_front_hall()
		"courtyard_gate": _enter_courtyard()
		"door_beadwork": _enter_beadwork_room()
		"bead_return": _return_to_courtyard("bead")
		"motif_phoenix": _inspect_motif(interaction_id, "凤凰", "梁月澄把账册线索藏进回首凤凰的尾羽。")
		"motif_peony": _inspect_motif(interaction_id, "牡丹", "何美珠常坐在牡丹纹靠背旁，也最清楚家宴碗碟的位置。")
		"motif_butterfly": _inspect_motif(interaction_id, "蝴蝶", "账房陈有德用‘蝴蝶过账’把数字从家账移到货账。")
		"motif_pomegranate": _inspect_motif(interaction_id, "石榴", "梁启文是唯一男嗣，石榴代表他认定属于自己的继承。")
		"beaded_shoe": _inspect_beaded_shoe()
		"bead_screen": _hide_behind_screen()
		"door_kitchen": _enter_kitchen()
		"kitchen_return": _return_to_courtyard("kitchen")
		"kitchen_recipe": _read_kitchen_recipe()
		"seat_liang_ruiting", "seat_chen_youde", "seat_he_meizhu", "seat_liang_yuecheng", "seat_liang_qiwen", "seat_achun": _choose_seat(interaction_id)
		"door_office": _enter_office()
		"office_return": _return_to_courtyard("office")
		"ledger_home": _read_ledger("home")
		"ledger_shipping": _read_ledger("shipping")
		"ledger_pharmacy": _read_ledger("pharmacy")
		"office_abacus": _inspect_abacus()
		"door_ancestor": _enter_ancestor_hall()
		"ancestor_return": _return_to_courtyard("ancestor")
		"ancestor_case": _show_evidence_case()
		"ancestor_terminal": _open_ending_terminal()


func _enter_front_hall() -> void:
	level.set_active_area("front")
	current_chapter = "第一关 · 消失的旅行团"
	current_objective = "按导览 App 扫描五件展品"
	player.teleport(Vector3(0, 0.05, 10.2), 0)
	_show_dialog("梁宅前厅", "黑木家具沿墙排开，彩色地砖一直通向后方天井。导览员让大家自由参观十分钟。", [{"text": "开始扫描", "action": _close_dialog}])
	_notify_app("前厅任务 · 已扫描 %d/5" % front_scanned.size())


func _scan_front_exhibit(interaction_id: String) -> void:
	var exhibit_name := str(FRONT_EXHIBITS[interaction_id])
	var was_new := not front_scanned.has(interaction_id)
	if was_new:
		front_scanned[interaction_id] = true
		level.set_photo_stage(front_scanned.size())
	var descriptions := {
		"exhibit_photo": "照片中梁月澄站在左侧。她的脸上有反复刮擦的痕迹，展签却只列了四位家属。",
		"exhibit_porcelain": "盖罐底部写着 1919。耳边传来瓷器轻碰声，但柜门没有动。",
		"exhibit_chair": "椅背内侧刻着一个很浅的‘澄’字。刚才坐在旁边的游客已经不见了。",
		"exhibit_clock": "座钟停在 19:19。秒针却在你靠近时倒走了七格。",
		"exhibit_letter": "信封写着 ‘Singapore, Straits Settlements’。内容提到梁瑞廷将在家宴后重签遗嘱。",
	}
	var action_text := "继续扫描" if front_scanned.size() < 5 else "抬头看向合照"
	_show_dialog(exhibit_name, descriptions[interaction_id], [{"text": action_text, "action": _after_front_scan}])
	if was_new:
		_notify_app("前厅任务 · 已扫描 %d/5" % front_scanned.size())


func _after_front_scan() -> void:
	if front_scanned.size() < 5:
		current_objective = "继续扫描前厅展品（%d/5）" % front_scanned.size()
		_close_dialog()
		return
	flags["front_complete"] = true
	_add_evidence("刮坏的家族照片")
	level.set_night_mode(true)
	current_objective = "穿过前厅，进入下雨的天井"
	_show_dialog(
		"第七位游客",
		"前厅里只剩雨声。合照中的人一个接一个消失，最后只剩梁月澄直视着镜头。\n\n手机自动弹出一句：\n[b]“第七位游客，请回到你的展柜。”[/b]",
		[{"text": "离开照片", "action": _close_dialog}]
	)
	_notify_app("异常档案已保存 · 梁月澄（资料缺失）")


func _enter_courtyard() -> void:
	if not flags["front_complete"]:
		_show_locked("导览任务尚未完成，天井门禁没有响应。")
		return
	level.set_active_area("courtyard")
	current_objective = "进入珠绣房，调查梁月澄留下的图案"
	player.teleport(Vector3(0, 0.05, -3.25), 0)
	_show_dialog("天井", "雨从敞开的屋面落进井中。木楼梯通向没有灯的二层，左右门楣分别写着“珠绣房”和“厨房”。", [{"text": "走进雨里", "action": _close_dialog}])


func _enter_beadwork_room() -> void:
	level.set_active_area("bead")
	current_chapter = "第二关 · 未完成的鞋"
	current_objective = "查看凤凰、牡丹、蝴蝶与石榴珠样"
	player.teleport(Vector3(-8.0, 0.05, -5.1), 90)
	_show_dialog("珠绣房", "梳妆镜蒙着灰，未完成的珠绣鞋放在桌中央。四枚珠样像一套被拆开的账册索引。", [{"text": "调查图案", "action": _close_dialog}])


func _inspect_motif(motif_id: String, motif_name: String, secret: String) -> void:
	if motifs_read.size() < 4 and not motifs_read.has(motif_id):
		motifs_read[motif_id] = true
		var action := _motif_read_complete if motifs_read.size() == 4 else _close_dialog
		_show_dialog(motif_name + "珠样", secret, [{"text": "记住图案", "action": action}])
		return
	if motifs_read.size() < 4:
		_show_dialog(motif_name + "珠样", secret, [{"text": "继续查看其他图案", "action": _close_dialog}])
		return
	if motif_attempt.size() >= 4:
		motif_attempt.clear()
	var expected: String = str(MOTIF_SOLUTION[motif_attempt.size()])
	if motif_id == expected:
		motif_attempt.append(motif_id)
		_notify_app("珠样顺序 · %d/4" % motif_attempt.size())
		if motif_attempt.size() == 4:
			current_objective = "检查桌上的未完成珠绣鞋"
			_show_dialog("图案吻合", "石榴的继承、蝴蝶的过账、凤凰的查账、牡丹的换碗，在鞋面拼成一条完整证词。", [{"text": "检查珠绣鞋", "action": _close_dialog}])
		else:
			_close_dialog()
	else:
		motif_attempt.clear()
		_show_dialog("珠线散开", "选择顺序不对。鞋面边缘的针脚提示：先是继承，再是转账，随后查账，最后有人换了碗。", [{"text": "重新排列", "action": _close_dialog}])


func _motif_read_complete() -> void:
	current_objective = "按事件顺序触碰四枚珠样"
	_show_dialog("鞋底暗语", "针脚把四个秘密串成一句话：\n\n[b]继承者起意 → 账房转账 → 月澄查账 → 家宴换碗[/b]", [{"text": "开始排列", "action": _close_dialog}])


func _inspect_beaded_shoe() -> void:
	if motif_attempt.size() < 4:
		_show_dialog("未完成的珠绣鞋", "鞋面缺了四段连接针脚。先读懂桌上的四枚珠样。", [{"text": "返回", "action": _close_dialog}])
		return
	_show_dialog("未完成的珠绣鞋", "鞋垫下面藏着梁月澄抄下的货账编号。房门外忽然传来男人拖着鞋底走路的声音。", [{"text": "关灯，寻找藏身处", "action": _start_bead_chase}])


func _start_bead_chase() -> void:
	_close_dialog()
	flags["chase_active"] = true
	shadow_actor.visible = true
	shadow_actor.global_position = Vector3(-7.6, 0.05, -5.0)
	current_objective = "躲到屏风后，避开梁启文的影子"
	_notify_app("警告 · 检测到未登记访客")


func _hide_behind_screen() -> void:
	if not flags["chase_active"]:
		_show_dialog("折叠屏风", "屏风后只容得下一个人。木板上有新鲜的指甲划痕。", [{"text": "退出来", "action": _close_dialog}])
		return
	flags["chase_active"] = false
	shadow_actor.visible = false
	flags["bead_complete"] = true
	_add_evidence("未完成的珠绣鞋")
	current_objective = "回到天井，进入厨房"
	_show_dialog("脚步远去", "影子停在屏风外，低声说：“账本不是女人该看的东西。”\n\n几秒后，珠绣房的灯重新亮起。", [{"text": "带走珠绣鞋", "action": _close_dialog}])


func _enter_kitchen() -> void:
	if not flags["bead_complete"]:
		_show_locked("厨房门上的珠绣纹样还没有完整亮起。")
		return
	level.set_active_area("kitchen")
	current_chapter = "第三关 · 最后一顿家宴"
	current_objective = "查看灶台旁的 Ayam Pongteh 食谱"
	player.teleport(Vector3(8.0, 0.05, -5.1), -90)
	_show_dialog("娘惹厨房", "炉火在无人添柴的灶里燃着。Tok Panjang 长桌摆着六只空碗，每一只都朝向一个不存在的客人。", [{"text": "调查食谱", "action": _close_dialog}])


func _read_kitchen_recipe() -> void:
	recipe_views += 1
	if recipe_views == 1:
		current_objective = "再次查看发生变化的食谱"
		_show_dialog("Ayam Pongteh", "豆酱、蒜头、黑酱油、椰糖、马铃薯、蓝姜。\n\n油渍下面似乎还有一层墨迹。", [{"text": "放回食谱", "action": _close_dialog}])
		return
	current_objective = "按材料顺序还原 1919 年家宴席位"
	_show_dialog("食谱变了", "豆酱 - 梁瑞廷\n蒜头 - 陈有德\n黑酱油 - 何美珠\n椰糖 - 梁月澄\n马铃薯 - 梁启文\n蓝姜 - 阿春\n\n这不是食材替换，而是一张[b]座位暗号[/b]。", [{"text": "开始摆放碗筷", "action": _close_dialog}])


func _choose_seat(seat_id: String) -> void:
	if recipe_views < 2:
		_show_dialog("空席", "你还不知道每只碗属于谁。", [{"text": "先找食谱", "action": _close_dialog}])
		return
	if flags["kitchen_complete"]:
		_show_dialog("1919 年家宴", "六只碗已经回到那一晚的位置。梁月澄的椅子仍然向后拉开。", [{"text": "离开长桌", "action": _close_dialog}])
		return
	var expected: String = str(SEAT_SOLUTION[seat_attempt.size()])
	if seat_id == expected:
		seat_attempt.append(seat_id)
		_notify_app("家宴席位 · %d/6" % seat_attempt.size())
		if seat_attempt.size() == 6:
			_complete_kitchen_puzzle()
		else:
			_close_dialog()
	else:
		seat_attempt.clear()
		_show_dialog("碗碟错位", "瓷碗同时轻响了一声，刚摆好的位置全部恢复原样。", [{"text": "按食谱重新摆放", "action": _close_dialog}])


func _complete_kitchen_puzzle() -> void:
	flags["kitchen_complete"] = true
	_add_evidence("油渍食谱")
	current_objective = "回到天井，进入账房"
	_show_dialog("最后一席", "摆到梁月澄的位置时，椅子自己向后拉开。\n\n阿春藏在油渍下的字显了出来：\n[b]“不是急病。老爷的药，最后进了大小姐的碗。”[/b]", [{"text": "记录厨房证词", "action": _close_dialog}])


func _enter_office() -> void:
	if not flags["kitchen_complete"]:
		_show_locked("账房门锁上浮着六只碗的轮廓。家宴还没有复原。")
		return
	level.set_active_area("office")
	current_chapter = "第四关 · 橡胶园的账册"
	current_objective = "比对家账、货账与药房账"
	player.teleport(Vector3(-6, 0.05, -11.7), 0)
	_show_dialog("梁宅账房", "三本账摊在桌上。窗外没有雨，但屋顶仍传来雨点声。算盘珠停在一个即将组成的年份上。", [{"text": "开始核账", "action": _close_dialog}])


func _read_ledger(ledger_id: String) -> void:
	ledgers_read[ledger_id] = true
	var texts := {
		"home": "家账：梁瑞廷准备把部分橡胶园收益交给梁月澄管理，用于保住祖宅并补发工钱。",
		"shipping": "货账：陈有德把三批橡胶写成损耗，款项却进入梁启文控制的空壳商号。",
		"pharmacy": "药房账：家宴当日下午，梁启文签收了一份本应给梁瑞廷的镇静药。",
	}
	var action := _all_ledgers_ready if ledgers_read.size() == 3 else _close_dialog
	_show_dialog("账册比对", texts[ledger_id], [{"text": "记录差异", "action": action}])


func _all_ledgers_ready() -> void:
	current_objective = "查看自动拨动的算盘"
	_show_dialog("三账交叉验证", "遗嘱、挪账与药物在同一场家宴交汇。梁月澄不是意外病逝，她是在揭穿账目后被灭口。", [{"text": "听见算盘声", "action": _close_dialog}])


func _inspect_abacus() -> void:
	if ledgers_read.size() < 3:
		_show_dialog("算盘", "珠子拨了几下又停住。还缺账册之间的对应关系。", [{"text": "继续核账", "action": _close_dialog}])
		return
	if not flags["office_complete"]:
		flags["office_complete"] = true
		_add_evidence("药房账")
		_add_evidence("橡胶货运单")
	current_objective = "带着五件证据进入祖先厅"
	_show_dialog("1919", "算盘无人触碰，却一遍遍拨出同一个数字：\n\n[b]1 · 9 · 1 · 9[/b]\n\n最后一颗珠子落下时，祖先厅的门锁响了。", [{"text": "收好账册证据", "action": _close_dialog}])


func _enter_ancestor_hall() -> void:
	if not flags["office_complete"]:
		_show_locked("祖先厅拒绝打开。供桌前还缺能证明梁月澄死因的账册。")
		return
	level.set_active_area("ancestor")
	current_chapter = "第五关 · 最后的展签"
	current_objective = "把五件证据放进中央展柜"
	player.teleport(Vector3(3, 0.05, -11.7), 0)
	_show_dialog("祖先厅", "祖先牌位在烛光中排成两列。中央展柜是空的，原本属于梁月澄的位置只有一枚没有文字的铜钉。", [{"text": "走向展柜", "action": _close_dialog}])


func _show_evidence_case() -> void:
	var entries: Array = []
	for item in REQUIRED_EVIDENCE:
		entries.append({
			"text": ("已放置 · " if placed_evidence.has(item) else "放置 · ") + item,
			"action": Callable(self, "_place_evidence").bind(item),
			"disabled": placed_evidence.has(item) or not evidence.has(item),
		})
	entries.append({"text": "离开展柜", "action": _close_dialog})
	var body := "证据 %d/5\n\n展柜要求每一件陈列物都能对应一个档案编号。" % placed_evidence.size()
	_show_dialog("梁月澄临时档案", body, entries)


func _place_evidence(item: String) -> void:
	if evidence.has(item) and not placed_evidence.has(item):
		placed_evidence.append(item)
		_notify_app("证据已登记 · %d/5" % placed_evidence.size())
	if placed_evidence.size() == REQUIRED_EVIDENCE.size():
		current_objective = "使用供桌前的档案终端生成最后展签"
		_show_dialog("证据链完整", "珠绣鞋、食谱、药房账、货运单与刮坏照片互相印证。空白铜钉上浮出了梁月澄的名字。", [{"text": "前往档案终端", "action": _close_dialog}])
	else:
		_show_evidence_case()


func _open_ending_terminal() -> void:
	if placed_evidence.size() < REQUIRED_EVIDENCE.size():
		_show_dialog("档案系统", "证据链不完整。系统可以生成一段适合游客阅读的说明，但无法确认真实死因。", [{"text": "返回展柜", "action": _close_dialog}])
		return
	_show_dialog(
		"最后的展签",
		"梁月澄\n1901-1919\n梁宅账册保管人\n被家族记录抹去者\n\n档案系统询问：要如何发布这份记录？",
		[
			{"text": "按证据编号发布真相", "action": _ending_truth},
			{"text": "改写成适合游客的家族传说", "action": _ending_lie},
			{"text": "烧毁账册与全部证据", "action": _ending_burn},
		]
	)


func _ending_truth() -> void:
	level.set_night_mode(false)
	_finish_ending("真相结局", "系统逐条列出照片、鞋面针脚、家宴席位、药房签收与橡胶货账。梁宅恢复白天，梁月澄的名字重新出现在族谱与展柜中。\n\n许安宁走出门时，街上的游客都回来了。只有导览 App 多出一条由梁月澄署名的感谢记录。")


func _ending_lie() -> void:
	_finish_ending("漂亮谎言结局", "许安宁要求系统把事件改成一段温柔的家族传说：大小姐远行，祖宅等她归来。门因此打开。\n\n第二天，梁月澄的展柜仍是空的。旁边新添了一张许安宁站在前厅里的照片。")


func _ending_burn() -> void:
	_finish_ending("烧毁账册结局", "火焰吞掉账册，梁宅所有声音在一瞬间停止。鬼影消失了一夜，家族也再没有可以被证明的罪。\n\n下一场雨开始时，导览 App 又对另一名游客说：‘第七位游客，请回到你的展柜。’")


func _finish_ending(ending_name: String, ending_text: String) -> void:
	flags["chase_active"] = false
	shadow_actor.visible = false
	current_chapter = "终章"
	current_objective = ending_name
	_update_hud()
	_show_dialog(ending_name, ending_text + "\n\n[b]THE LAST LABEL · 第一章完[/b]", [{"text": "重新开始", "action": _restart_game}, {"text": "退出游戏", "action": _quit_game}])


func _return_to_courtyard(from_room: String) -> void:
	level.set_active_area("courtyard")
	var destination := Vector3.ZERO
	match from_room:
		"bead": destination = Vector3(-4.7, 0.05, -5.1)
		"kitchen": destination = Vector3(4.7, 0.05, -5.1)
		"office": destination = Vector3(-2.1, 0.05, -8.8)
		"ancestor": destination = Vector3(2.1, 0.05, -8.8)
	player.teleport(destination, 0)
	if flags["office_complete"]:
		current_objective = "进入祖先厅"
	elif flags["kitchen_complete"]:
		current_objective = "进入账房"
	elif flags["bead_complete"]:
		current_objective = "进入厨房"
	else:
		current_objective = "解开珠绣房的图案"
	_close_dialog()


func _build_shadow_actor() -> void:
	shadow_actor = Node3D.new()
	shadow_actor.name = "LiangQiwenShadow"
	add_child(shadow_actor)
	var material := StandardMaterial3D.new()
	material.albedo_color = Color("070809")
	material.roughness = 1.0
	material.emission_enabled = true
	material.emission = Color("090b0c")
	var body := MeshInstance3D.new()
	var capsule := CapsuleMesh.new()
	capsule.radius = 0.34
	capsule.height = 1.55
	body.mesh = capsule
	body.position.y = 0.85
	body.material_override = material
	shadow_actor.add_child(body)
	var head := MeshInstance3D.new()
	var sphere := SphereMesh.new()
	sphere.radius = 0.24
	sphere.height = 0.48
	head.mesh = sphere
	head.position.y = 1.73
	head.material_override = material
	shadow_actor.add_child(head)
	shadow_actor.visible = false


func _update_shadow_chase(delta: float) -> void:
	if not flags["chase_active"] or not shadow_actor.visible:
		return
	var difference := player.global_position - shadow_actor.global_position
	difference.y = 0
	if difference.length() < 1.05:
		flags["chase_active"] = false
		shadow_actor.visible = false
		player.teleport(Vector3(-12.5, 0.05, -5.0), 90)
		_show_dialog("影子抓住了你", "画面像旧胶片一样跳回珠绣房门口。脚步声又从头开始。", [{"text": "重新关灯", "action": _start_bead_chase}])
		return
	var direction := difference.normalized()
	shadow_actor.global_position += direction * 1.35 * delta
	shadow_actor.rotation.y = atan2(-direction.x, -direction.z)


func _show_locked(message: String) -> void:
	_show_dialog("门还没有承认你", message, [{"text": "退开", "action": _close_dialog}])


func _show_dialog(title_text: String, body_text: String, entries: Array) -> void:
	dialog_title.text = title_text
	dialog_body.text = body_text
	for child in dialog_actions.get_children():
		child.queue_free()
	for entry in entries:
		var button := Button.new()
		button.text = str(entry.get("text", "继续"))
		button.custom_minimum_size = Vector2(0, 38)
		button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		button.disabled = bool(entry.get("disabled", false))
		button.add_theme_font_size_override("font_size", 16)
		var action: Callable = entry.get("action", Callable())
		if action.is_valid():
			button.pressed.connect(action)
		dialog_actions.add_child(button)
	dialog_panel.visible = true
	player.set_controls_enabled(false)


func _close_dialog() -> void:
	dialog_panel.visible = false
	player.set_controls_enabled(true)
	_update_hud()


func _notify_app(message: String) -> void:
	app_label.text = "梁宅导览\n" + message
	app_panel.visible = true
	app_timer = 4.5


func _update_app_notification(delta: float) -> void:
	if app_timer <= 0:
		return
	app_timer -= delta
	if app_timer <= 0:
		app_panel.visible = false


func _add_evidence(item: String) -> void:
	if not evidence.has(item):
		evidence.append(item)
	_update_hud()


func _update_hud() -> void:
	chapter_label.text = current_chapter.to_upper()
	objective_label.text = current_objective
	evidence_label.text = "档案证据  %d / 5" % evidence.size()


func _panel_style(background: Color, border: Color, radius: int) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = background
	style.border_color = border
	style.set_border_width_all(1)
	style.set_corner_radius_all(radius)
	return style


func _margin(horizontal: int, vertical: int) -> MarginContainer:
	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", horizontal)
	margin.add_theme_constant_override("margin_right", horizontal)
	margin.add_theme_constant_override("margin_top", vertical)
	margin.add_theme_constant_override("margin_bottom", vertical)
	return margin


func _capture_preview() -> void:
	title_overlay.visible = false
	dialog_panel.visible = false
	level.set_active_area("front")
	player.teleport(Vector3(0, 0.05, 10.2), 0)
	player.set_controls_enabled(false)
	for frame in range(90):
		await get_tree().process_frame
	print("CAPTURE_FPS=", Engine.get_frames_per_second())
	var image := get_viewport().get_texture().get_image()
	image.save_png("res://preview_front.png")
	get_tree().quit()

func _restart_game() -> void:
	get_tree().reload_current_scene()


func _quit_game() -> void:
	get_tree().quit()
