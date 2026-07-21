extends AudioStreamPlayer

const SAMPLE_RATE := 22050.0
const NOTE_LENGTH := 3.2
const NIGHT_NOTES := [57, 60, 64, 62, -1, 60]

var playback: AudioStreamGeneratorPlayback
var sample_clock := 0.0
var filtered_noise := 0.0
var crackle_envelope := 0.0
var night_mix := 0.0
var rng := RandomNumberGenerator.new()


func _ready() -> void:
	if DisplayServer.get_name() == "headless" or OS.get_cmdline_user_args().has("capture"):
		set_process(false)
		return
	var generator := AudioStreamGenerator.new()
	generator.mix_rate = SAMPLE_RATE
	generator.buffer_length = 0.45
	stream = generator
	volume_db = -4.0
	rng.seed = 1919
	play()
	playback = get_stream_playback() as AudioStreamGeneratorPlayback


func _exit_tree() -> void:
	stop()
	playback = null


func _process(delta: float) -> void:
	if not is_instance_valid(playback):
		return
	var game_flags = get_parent().get("flags")
	var night_target := 0.0
	if game_flags is Dictionary and bool(game_flags.get("front_complete", false)):
		night_target = 1.0
	night_mix = move_toward(night_mix, night_target, delta * 0.18)
	var frames := mini(playback.get_frames_available(), 2048)
	for _frame in range(frames):
		playback.push_frame(_make_frame())


func _make_frame() -> Vector2:
	sample_clock += 1.0 / SAMPLE_RATE
	var white_noise := rng.randf_range(-1.0, 1.0)
	filtered_noise = lerp(filtered_noise, white_noise, 0.026)
	var rain: float = filtered_noise * lerpf(0.032, 0.046, night_mix)
	var house_hum: float = sin(TAU * 48.0 * sample_clock) * lerpf(0.006, 0.012, night_mix)
	house_hum += sin(TAU * 96.0 * sample_clock) * 0.0025

	if rng.randf() < lerp(0.00022, 0.00075, night_mix):
		crackle_envelope = rng.randf_range(0.025, 0.09)
	var crackle: float = white_noise * crackle_envelope
	crackle_envelope *= 0.91

	var melody: float = _night_melody() * night_mix
	var sample: float = clampf(rain + house_hum + crackle + melody, -0.35, 0.35)
	return Vector2(sample, sample * 0.97 + rain * 0.03)


func _night_melody() -> float:
	var note_slot := int(sample_clock / NOTE_LENGTH) % NIGHT_NOTES.size()
	var midi_note: int = NIGHT_NOTES[note_slot]
	if midi_note < 0:
		return 0.0
	var note_time := fmod(sample_clock, NOTE_LENGTH)
	if note_time > 1.45:
		return 0.0
	var frequency: float = 440.0 * pow(2.0, (float(midi_note) - 69.0) / 12.0)
	var warble: float = sin(TAU * 0.73 * sample_clock) * 0.006
	var envelope: float = minf(note_time * 5.0, 1.0) * exp(-1.72 * note_time)
	var tone: float = sin(TAU * frequency * sample_clock * (1.0 + warble))
	tone += sin(TAU * frequency * 2.0 * sample_clock) * 0.14
	return tone * envelope * 0.022
