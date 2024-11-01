class_name PushBox4
extends CameraControllerBase

@export var top_left: Vector2
@export var bottom_right: Vector2
@export var autoscroll_speed: Vector3
@export var box_width: float = 10.0
@export var box_height: float = 10.0

@export var lead_speed: float = 15.0               
@export var catchup_delay_duration: float = 0   
@export var catchup_speed: float = 12.0           
@export var leash_distance: float = 100.0          

var last_player_position: Vector3 = Vector3()
var last_move_time: float = 0.0

func _ready() -> void:
	super()
	position = target.position
	last_player_position = target.position

func _process(delta: float) -> void:
	if !current:
		return

	# Autoscroll the frame on the x and z axes
	global_position.x += autoscroll_speed.x * delta
	global_position.z += autoscroll_speed.z * delta

	var tpos = target.global_position
	var cpos = global_position
	var distance_to_player = cpos.distance_to(tpos)

	# Check if player is moving
	var player_is_moving = last_player_position.distance_to(tpos) > 0.1

	# Update last move instance
	if player_is_moving:
		last_move_time = Time.get_ticks_msec() / 2000.0

	# Calculating lead effect when the player is moving or not
	if player_is_moving:
		var lead_target = tpos + (tpos - last_player_position).normalized() * lead_speed
		global_position = global_position.lerp(lead_target, delta)

	# Catch-up to player when stopped, with a delay, need to redo
	elif Time.get_ticks_msec() / 2000.0 - last_move_time > catchup_delay_duration:
		global_position = global_position.lerp(tpos, catchup_speed * delta / distance_to_player)

	# Keep camera within leash distance from the player, redo this too
	if distance_to_player > leash_distance:
		global_position = global_position.lerp(tpos, delta)

	# Frame boundary edges
	var frame_left = cpos.x + top_left.x
	var frame_right = cpos.x + bottom_right.x
	var frame_top = cpos.z + top_left.y
	var frame_bottom = cpos.z + bottom_right.y

	# Boundary checks
	if tpos.x < frame_left:
		target.global_position.x = frame_left
	if tpos.x > frame_right:
		target.global_position.x = frame_right
	if tpos.z > frame_top:
		target.global_position.z = frame_top
	if tpos.z < frame_bottom:
		target.global_position.z = frame_bottom

	# Update last player position
	last_player_position = tpos

	# Draw logic if enabled
	if draw_camera_logic:
		draw_logic()

	super(delta)

func draw_logic() -> void:
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()

	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF

	# Frame corners based on top_left and bottom_right settings
	var left: float = -box_width / 2
	var right: float = box_width / 2
	var top: float = -box_height / 2
	var bottom: float = box_height / 2

	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)

	# Draw frame border
	immediate_mesh.surface_add_vertex(Vector3(right, 0, top))
	immediate_mesh.surface_add_vertex(Vector3(right, 0, bottom))
	immediate_mesh.surface_add_vertex(Vector3(right, 0, bottom))
	immediate_mesh.surface_add_vertex(Vector3(left, 0, bottom))
	immediate_mesh.surface_add_vertex(Vector3(left, 0, bottom))
	immediate_mesh.surface_add_vertex(Vector3(left, 0, top))
	immediate_mesh.surface_add_vertex(Vector3(left, 0, top))
	immediate_mesh.surface_add_vertex(Vector3(right, 0, top))

	# Draw 5x5 unit cross in the center if enabled
	if draw_camera_logic:
		immediate_mesh.surface_add_vertex(Vector3(-2.5, 0, 0))
		immediate_mesh.surface_add_vertex(Vector3(2.5, 0, 0))
		immediate_mesh.surface_add_vertex(Vector3(0, 0, -2.5))
		immediate_mesh.surface_add_vertex(Vector3(0, 0, 2.5))

	immediate_mesh.surface_end()

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.BLACK

	add_child(mesh_instance)
	mesh_instance.global_transform = Transform3D.IDENTITY
	mesh_instance.global_position = Vector3(global_position.x, target.global_position.y, global_position.z)

	# Free the mesh after one frame update
	await get_tree().process_frame
	mesh_instance.queue_free()
