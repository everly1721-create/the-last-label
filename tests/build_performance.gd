extends SceneTree

const HouseBuilder = preload("res://scripts/leong_house_builder.gd")


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	var level := HouseBuilder.new()
	root.add_child(level)
	var started := Time.get_ticks_msec()
	level.build()
	print("AREA_BUILD outside=%dms" % (Time.get_ticks_msec() - started))
	await process_frame

	for area_id in ["front", "courtyard", "bead", "kitchen", "office", "ancestor"]:
		started = Time.get_ticks_msec()
		level.set_active_area(area_id)
		print("AREA_BUILD %s=%dms" % [area_id, Time.get_ticks_msec() - started])
		await process_frame

	level.queue_free()
	await process_frame
	quit(0)
