extends CharacterBody3D

signal interaction_requested(interaction_id: String)

const WALK_SPEED := 2.65
const RUN_SPEED := 4.4
const ACCELERATION := 12.0
const MOUSE_SENSITIVITY := 0.0023
const CAMERA_DISTANCE := 3.25
const FALL_LIMIT := -4.0
const CHARACTER_SCENE := preload("res://assets/third_party/quaternius_women_individual/glTF/Casual.gltf")

var controls_enabled := false
var camera_yaw := 0.0
var camera_pitch := -0.12
var camera_rig: Node3D
var pitch_pivot: Node3D
var spring_arm: SpringArm3D
var camera: Camera3D
var interaction_ray: RayCast3D
var visual_root: Node3D
var animation_player: AnimationPlayer
var current_animation := ""
var last_safe_position := Vector3.ZERO


func _ready() -> void:
	last_safe_position = global_position
	floor_snap_length = 0.35
	floor_max_angle = deg_to_rad(46.0)
	collision_layer = 1
	collision_mask = 1
	_build_collider()
	_build_character()
	_build_camera()


func _exit_tree() -> void:
	if is_instance_valid(camera_rig):
		camera_rig.queue_free()


func _physics_process(delta: float) -> void:
	if global_position.y < FALL_LIMIT:
		_recover_from_fall()
		return
	_update_camera_follow(delta)
	var input_vector := Vector2.ZERO
	if controls_enabled and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		input_vector.x = float(Input.is_key_pressed(KEY_D)) - float(Input.is_key_pressed(KEY_A))
		input_vector.y = float(Input.is_key_pressed(KEY_W)) - float(Input.is_key_pressed(KEY_S))
		input_vector = input_vector.normalized()

	var camera_basis := Basis(Vector3.UP, camera_yaw)
	var forward := -camera_basis.z
	var right := camera_basis.x
	var direction := (right * input_vector.x + forward * input_vector.y).normalized()
	var running := Input.is_key_pressed(KEY_SHIFT)
	var target_speed := RUN_SPEED if running else WALK_SPEED
	velocity.x = move_toward(velocity.x, direction.x * target_speed, ACCELERATION * delta)
	velocity.z = move_toward(velocity.z, direction.z * target_speed, ACCELERATION * delta)
	if not is_on_floor():
		velocity.y -= 20.0 * delta
	else:
		velocity.y = -0.1

	if direction.length_squared() > 0.01:
		var target_yaw := atan2(-direction.x, -direction.z)
		rotation.y = lerp_angle(rotation.y, target_yaw, 1.0 - exp(-10.0 * delta))
	move_and_slide()
	if is_on_floor():
		last_safe_position = global_position
	_animate_character(direction.length(), running)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and controls_enabled and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		camera_yaw -= event.relative.x * MOUSE_SENSITIVITY
		camera_pitch = clamp(camera_pitch - event.relative.y * MOUSE_SENSITIVITY, -0.82, 0.48)
		camera_rig.rotation.y = camera_yaw
		pitch_pivot.rotation.x = camera_pitch
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if controls_enabled:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	elif event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_ESCAPE and controls_enabled:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		elif event.keycode == KEY_E and controls_enabled:
			var target := get_interaction_target()
			if target:
				interaction_requested.emit(str(target.get_meta("interaction_id")))


func _build_collider() -> void:
	var collider := CollisionShape3D.new()
	var capsule := CapsuleShape3D.new()
	capsule.radius = 0.34
	capsule.height = 1.72
	collider.position.y = 0.86
	collider.shape = capsule
	add_child(collider)


func _build_character() -> void:
	visual_root = Node3D.new()
	visual_root.name = "XuAnning"
	add_child(visual_root)
	var character := CHARACTER_SCENE.instantiate()
	character.name = "CasualTourist"
	character.rotation_degrees.y = 180.0
	visual_root.add_child(character)
	var animation_players := character.find_children("*", "AnimationPlayer", true, false)
	if not animation_players.is_empty():
		animation_player = animation_players[0] as AnimationPlayer
		_play_animation("Idle", 1.0)


func _build_camera() -> void:
	camera_rig = Node3D.new()
	camera_rig.name = "ThirdPersonCameraRig"
	get_parent().add_child.call_deferred(camera_rig)
	await get_tree().process_frame
	if not is_instance_valid(camera_rig):
		return
	camera_rig.global_position = global_position + Vector3(0, 1.47, 0)
	camera_rig.rotation.y = camera_yaw
	pitch_pivot = Node3D.new()
	pitch_pivot.rotation.x = camera_pitch
	camera_rig.add_child(pitch_pivot)
	var shoulder := Node3D.new()
	shoulder.position.x = 0.58
	pitch_pivot.add_child(shoulder)
	spring_arm = SpringArm3D.new()
	spring_arm.spring_length = CAMERA_DISTANCE
	spring_arm.margin = 0.18
	spring_arm.collision_mask = 1
	shoulder.add_child(spring_arm)
	camera = Camera3D.new()
	camera.current = true
	camera.fov = 64.0
	spring_arm.add_child(camera)
	interaction_ray = RayCast3D.new()
	interaction_ray.target_position = Vector3(0, 0, -6.5)
	interaction_ray.collision_mask = 2
	interaction_ray.collide_with_areas = true
	interaction_ray.collide_with_bodies = false
	interaction_ray.enabled = true
	camera.add_child(interaction_ray)


func _recover_from_fall() -> void:
	global_position = last_safe_position + Vector3(0, 0.15, 0)
	velocity = Vector3.ZERO
	if is_instance_valid(camera_rig):
		camera_rig.global_position = global_position + Vector3(0, 1.47, 0)


func _update_camera_follow(delta: float) -> void:
	if not is_instance_valid(camera_rig) or not camera_rig.is_inside_tree():
		return
	var target := global_position + Vector3(0, 1.47, 0)
	camera_rig.global_position = camera_rig.global_position.lerp(target, 1.0 - exp(-14.0 * delta))


func _animate_character(move_amount: float, running: bool) -> void:
	if move_amount <= 0.05:
		_play_animation("Idle", 1.0)
	elif running:
		_play_animation("Run", 1.05)
	else:
		_play_animation("Walk", 1.0)


func _play_animation(animation_name: String, speed: float) -> void:
	if not is_instance_valid(animation_player):
		return
	if current_animation == animation_name:
		animation_player.speed_scale = speed
		return
	if animation_player.has_animation(animation_name):
		current_animation = animation_name
		animation_player.play(animation_name, 0.18, speed)


func get_interaction_target() -> Area3D:
	if not is_instance_valid(interaction_ray):
		return null
	interaction_ray.force_raycast_update()
	if interaction_ray.is_colliding():
		var target := interaction_ray.get_collider()
		if target is Area3D and target.has_meta("interaction_id"):
			return target
	return null


func set_controls_enabled(value: bool) -> void:
	controls_enabled = value
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if value else Input.MOUSE_MODE_VISIBLE


func teleport(destination: Vector3, yaw_degrees: float = 0.0) -> void:
	global_position = destination
	last_safe_position = destination
	rotation_degrees.y = yaw_degrees
	camera_yaw = deg_to_rad(yaw_degrees)
	velocity = Vector3.ZERO
	if is_instance_valid(camera_rig):
		camera_rig.global_position = destination + Vector3(0, 1.47, 0)
		camera_rig.rotation.y = camera_yaw
