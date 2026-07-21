extends SceneTree

var han := RegEx.new()


func _initialize() -> void:
	han.compile("[\\x{4E00}-\\x{9FFF}]")
	call_deferred("_run")


func _run() -> void:
	for language in ["en", "ms"]:
		await _run_language(language)
	print("LOCALIZATION_SMOKE_PASS languages=en,ms")
	quit(0)


func _run_language(language: String) -> void:
	var packed := load("res://scenes/Main.tscn") as PackedScene
	var game := packed.instantiate()
	root.add_child(game)
	for _frame in range(3):
		await process_frame
	game.call("_set_language", language, false)
	_check_text(game.get("place_label").text, language, "title place")
	_check_text(game.get("game_title_label").text, language, "title")
	_check_text(game.get("subtitle_label").text, language, "subtitle")

	game.call("_start_game")
	_check_ui(game, language, "opening 1")
	game.call("_opening_two")
	_check_ui(game, language, "opening 2")
	game.call("_finish_opening")
	game.call("_enter_front_hall")
	_check_ui(game, language, "front hall")
	for exhibit_id in ["exhibit_photo", "exhibit_porcelain", "exhibit_chair", "exhibit_clock", "exhibit_letter"]:
		game.call("_scan_front_exhibit", exhibit_id)
		_check_ui(game, language, exhibit_id)
		game.call("_after_front_scan")

	game.call("_enter_courtyard")
	_check_ui(game, language, "courtyard")
	game.call("_enter_beadwork_room")
	var motif_data := {
		"motif_pomegranate": ["石榴", "梁启文是唯一男嗣，石榴代表他认定属于自己的继承。"],
		"motif_butterfly": ["蝴蝶", "账房陈有德用‘蝴蝶过账’把数字从家账移到货账。"],
		"motif_phoenix": ["凤凰", "梁月澄把账册线索藏进回首凤凰的尾羽。"],
		"motif_peony": ["牡丹", "何美珠常坐在牡丹纹靠背旁，也最清楚家宴碗碟的位置。"],
	}
	for motif_id in motif_data:
		game.call("_inspect_motif", motif_id, motif_data[motif_id][0], motif_data[motif_id][1])
		_check_ui(game, language, motif_id + " read")
	for motif_id in ["motif_pomegranate", "motif_butterfly", "motif_phoenix", "motif_peony"]:
		game.call("_inspect_motif", motif_id, motif_data[motif_id][0], motif_data[motif_id][1])
		_check_ui(game, language, motif_id + " solve")
	game.call("_inspect_beaded_shoe")
	_check_ui(game, language, "beaded shoe")
	game.call("_start_bead_chase")
	game.call("_hide_behind_screen")
	_check_ui(game, language, "screen hide")

	game.call("_enter_kitchen")
	_check_ui(game, language, "kitchen")
	game.call("_read_kitchen_recipe")
	_check_ui(game, language, "recipe 1")
	game.call("_read_kitchen_recipe")
	_check_ui(game, language, "recipe 2")
	for seat_id in ["seat_liang_ruiting", "seat_chen_youde", "seat_he_meizhu", "seat_liang_yuecheng", "seat_liang_qiwen", "seat_achun"]:
		game.call("_choose_seat", seat_id)
		_check_ui(game, language, seat_id)

	game.call("_enter_office")
	_check_ui(game, language, "office")
	for ledger_id in ["home", "shipping", "pharmacy"]:
		game.call("_read_ledger", ledger_id)
		_check_ui(game, language, "ledger " + ledger_id)
	game.call("_inspect_abacus")
	_check_ui(game, language, "abacus")

	game.call("_enter_ancestor_hall")
	_check_ui(game, language, "ancestor")
	game.call("_show_evidence_case")
	_check_ui(game, language, "evidence case")
	for item in game.get("REQUIRED_EVIDENCE"):
		game.call("_place_evidence", item)
		_check_ui(game, language, "place evidence")
	game.call("_open_ending_terminal")
	_check_ui(game, language, "ending terminal")
	for ending_method in ["_ending_truth", "_ending_lie", "_ending_burn"]:
		game.call(ending_method)
		_check_ui(game, language, ending_method)

	for area in game.get("level").find_children("*", "Area3D", true, false):
		if area.has_meta("prompt"):
			_check_text(game.call("_t", str(area.get_meta("prompt"))), language, "prompt " + area.name)

	game.queue_free()
	await process_frame


func _check_ui(game: Node, language: String, label: String) -> void:
	game.call("_update_hud")
	for text_value in [
		game.get("dialog_title").text,
		game.get("dialog_body").text,
		game.get("chapter_label").text,
		game.get("objective_label").text,
		game.get("evidence_label").text,
		game.get("app_label").text,
	]:
		_check_text(text_value, language, label)
	for child in game.get("dialog_actions").get_children():
		if child is Button:
			_check_text(child.text, language, label + " button")


func _check_text(value: String, language: String, label: String) -> void:
	if han.search(value) == null:
		return
	push_error("LOCALIZATION_SMOKE_FAIL [%s] %s: %s" % [language, label, value])
	quit(1)
