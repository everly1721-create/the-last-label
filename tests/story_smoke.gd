extends SceneTree


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	var packed := load("res://scenes/Main.tscn") as PackedScene
	_check(packed != null, "Main scene loads")
	var game := packed.instantiate()
	root.add_child(game)
	for _frame in range(3):
		await process_frame

	game.call("_start_game")
	game.call("_finish_opening")
	game.call("_enter_front_hall")
	for exhibit_id in ["exhibit_photo", "exhibit_porcelain", "exhibit_chair", "exhibit_clock", "exhibit_letter"]:
		game.call("_scan_front_exhibit", exhibit_id)
		game.call("_after_front_scan")
	_check(bool(game.get("flags")["front_complete"]), "Front hall completes")

	game.call("_enter_courtyard")
	game.call("_enter_beadwork_room")
	var motif_data := {
		"motif_pomegranate": ["Pomegranate", "Inheritance"],
		"motif_butterfly": ["Butterfly", "Transfer"],
		"motif_phoenix": ["Phoenix", "Audit"],
		"motif_peony": ["Peony", "Bowl"],
	}
	for motif_id in motif_data:
		game.call("_inspect_motif", motif_id, motif_data[motif_id][0], motif_data[motif_id][1])
	for motif_id in ["motif_pomegranate", "motif_butterfly", "motif_phoenix", "motif_peony"]:
		game.call("_inspect_motif", motif_id, motif_data[motif_id][0], motif_data[motif_id][1])
	game.call("_inspect_beaded_shoe")
	game.call("_start_bead_chase")
	game.call("_hide_behind_screen")
	_check(bool(game.get("flags")["bead_complete"]), "Beadwork room completes")

	game.call("_enter_kitchen")
	game.call("_read_kitchen_recipe")
	game.call("_read_kitchen_recipe")
	for seat_id in ["seat_liang_ruiting", "seat_chen_youde", "seat_he_meizhu", "seat_liang_yuecheng", "seat_liang_qiwen", "seat_achun"]:
		game.call("_choose_seat", seat_id)
	_check(bool(game.get("flags")["kitchen_complete"]), "Kitchen completes")

	game.call("_enter_office")
	for ledger_id in ["home", "shipping", "pharmacy"]:
		game.call("_read_ledger", ledger_id)
	game.call("_inspect_abacus")
	_check(bool(game.get("flags")["office_complete"]), "Office completes")
	_check(game.get("evidence").size() == 5, "Five evidence items collected")

	game.call("_enter_ancestor_hall")
	for item in game.get("REQUIRED_EVIDENCE"):
		game.call("_place_evidence", item)
	_check(game.get("placed_evidence").size() == 5, "Five evidence items placed")
	game.call("_open_ending_terminal")

	game.call("_ending_truth")
	_check(game.get("current_objective") == "真相结局", "Truth ending")
	game.call("_ending_lie")
	_check(game.get("current_objective") == "漂亮谎言结局", "Pretty lie ending")
	game.call("_ending_burn")
	_check(game.get("current_objective") == "烧毁账册结局", "Burn ending")

	print("STORY_SMOKE_PASS evidence=5 endings=3")
	game.queue_free()
	await process_frame
	quit(0)


func _check(condition: bool, label: String) -> void:
	if condition:
		return
	push_error("STORY_SMOKE_FAIL: " + label)
	quit(1)
