extends "res://scripts/game_v2.gd"

const Localizer = preload("res://scripts/localization.gd")
const TITLE_TEXTURE = preload("res://assets/textures/leong_family_1919.png")
const SETTINGS_PATH := "user://settings.cfg"

var language := "zh"
var place_label: Label
var game_title_label: Label
var subtitle_label: Label
var language_caption: Label
var start_button: Button
var quit_button: Button
var language_buttons := {}


func _ready() -> void:
	_load_language()
	super()
	dialog_panel.anchor_top = 0.49
	dialog_panel.anchor_bottom = 0.96
	dialog_body.custom_minimum_size.y = 98
	dialog_body.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	dialog_body.add_theme_constant_override("line_separation", 6)
	_refresh_localized_ui()


func _process(delta: float) -> void:
	super(delta)
	if not is_instance_valid(prompt_label) or not prompt_label.visible:
		return
	if prompt_label.text.begins_with("E  "):
		prompt_label.text = "E  " + _t(prompt_label.text.trim_prefix("E  "))
	else:
		prompt_label.text = _t(prompt_label.text)


func _build_title_overlay(canvas: CanvasLayer) -> void:
	title_overlay = Control.new()
	title_overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	canvas.add_child(title_overlay)

	var backdrop := TextureRect.new()
	backdrop.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	backdrop.texture = TITLE_TEXTURE
	backdrop.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	backdrop.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	backdrop.modulate = Color(0.28, 0.31, 0.28, 1)
	title_overlay.add_child(backdrop)

	var shade := ColorRect.new()
	shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	shade.color = Color(0.01, 0.02, 0.018, 0.58)
	title_overlay.add_child(shade)

	var title_box := VBoxContainer.new()
	title_box.anchor_left = 0.075
	title_box.anchor_right = 0.69
	title_box.anchor_top = 0.11
	title_box.anchor_bottom = 0.9
	title_box.add_theme_constant_override("separation", 10)
	title_overlay.add_child(title_box)

	place_label = Label.new()
	place_label.add_theme_font_size_override("font_size", 16)
	place_label.add_theme_color_override("font_color", Color("c4b98f"))
	title_box.add_child(place_label)

	game_title_label = Label.new()
	game_title_label.add_theme_font_size_override("font_size", 44)
	game_title_label.add_theme_color_override("font_color", Color("f0e7ca"))
	game_title_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	title_box.add_child(game_title_label)

	subtitle_label = Label.new()
	subtitle_label.custom_minimum_size = Vector2(0, 48)
	subtitle_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	subtitle_label.add_theme_font_size_override("font_size", 18)
	subtitle_label.add_theme_color_override("font_color", Color("b9c5bf"))
	title_box.add_child(subtitle_label)

	language_caption = Label.new()
	language_caption.add_theme_font_size_override("font_size", 13)
	language_caption.add_theme_color_override("font_color", Color("9eaa9f"))
	title_box.add_child(language_caption)

	var language_row := HBoxContainer.new()
	language_row.add_theme_constant_override("separation", 4)
	title_box.add_child(language_row)
	for code in Localizer.SUPPORTED:
		var button := Button.new()
		button.text = str(Localizer.LANGUAGE_NAMES[code])
		button.toggle_mode = true
		button.custom_minimum_size = Vector2(136, 40)
		button.add_theme_font_size_override("font_size", 15)
		button.pressed.connect(_set_language.bind(code, true))
		language_row.add_child(button)
		language_buttons[code] = button

	var spacer := Control.new()
	spacer.custom_minimum_size.y = 8
	title_box.add_child(spacer)

	start_button = Button.new()
	start_button.custom_minimum_size = Vector2(412, 48)
	start_button.add_theme_font_size_override("font_size", 18)
	start_button.pressed.connect(_start_game)
	title_box.add_child(start_button)

	quit_button = Button.new()
	quit_button.custom_minimum_size = Vector2(412, 40)
	quit_button.add_theme_font_size_override("font_size", 15)
	quit_button.pressed.connect(_quit_game)
	title_box.add_child(quit_button)
	_refresh_title_text()


func _show_dialog(title_text: String, body_text: String, entries: Array) -> void:
	var localized_entries: Array = []
	for entry in entries:
		var localized: Dictionary = entry.duplicate()
		localized["text"] = _t(str(entry.get("text", "继续")))
		localized_entries.append(localized)
	super(_t(title_text), _t(body_text), localized_entries)
	for child in dialog_actions.get_children():
		if child is Button:
			child.add_theme_font_size_override("font_size", 14 if language != "zh" else 16)


func _notify_app(message: String) -> void:
	app_label.text = _t("梁宅导览") + "\n" + _t(message)
	app_panel.visible = true
	app_timer = 4.5


func _update_hud() -> void:
	if not is_instance_valid(chapter_label):
		return
	chapter_label.text = _t(current_chapter).to_upper()
	objective_label.text = _t(current_objective)
	evidence_label.text = _t("档案证据  %d / 5" % evidence.size())


func _set_language(code: String, persist: bool = true) -> void:
	if not Localizer.SUPPORTED.has(code):
		return
	language = code
	if persist:
		_save_language()
	_refresh_localized_ui()


func _refresh_localized_ui() -> void:
	_refresh_title_text()
	_update_hud()
	for code in language_buttons:
		var button: Button = language_buttons[code]
		button.button_pressed = str(code) == language


func _refresh_title_text() -> void:
	if not is_instance_valid(place_label):
		return
	place_label.text = _t("香兰港 · TANJONG SERAI")
	game_title_label.text = _t("THE LAST LABEL\n最后的展签")
	subtitle_label.text = _t("一段发生在虚构海峡祖屋梁宅的档案恐怖故事")
	language_caption.text = _t("语言 / LANGUAGE")
	start_button.text = _t("开始参观")
	quit_button.text = _t("退出")


func _load_language() -> void:
	var settings := ConfigFile.new()
	if settings.load(SETTINGS_PATH) == OK:
		var saved := str(settings.get_value("accessibility", "language", "zh"))
		if Localizer.SUPPORTED.has(saved):
			language = saved


func _save_language() -> void:
	var settings := ConfigFile.new()
	settings.set_value("accessibility", "language", language)
	settings.save(SETTINGS_PATH)


func _t(source: String) -> String:
	return Localizer.text(source, language)
