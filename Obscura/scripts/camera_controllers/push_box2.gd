class_name PushBox2
extends CameraControllerBase

@export var box_width: float = 10.0
@export var box_height: float = 10.0

@export var top_left: Vector2         
@export var bottom_right: Vector2     
@export var autoscroll_speed: Vector3 

func _ready() -> void:
	super()
	position = target.position

func _process(delta: float) -> void:
	if !current:
		return

	# Autoscroll camera on the x and z axes, creating the forward movement
	global_position.x += autoscroll_speed.x * delta
	global_position.z += autoscroll_speed.z * delta

	var tpos = target.global_position
	var cpos = global_position

	# Framing boundary edges
	var frame_left = cpos.x + top_left.x
	var frame_right = cpos.x + bottom_right.x
	var frame_top = cpos.z + top_left.y
	var frame_bottom = cpos.z + bottom_right.y

	# Boundary checks for player
	if tpos.x < frame_left:
		target.global_position.x = frame_left
	elif tpos.x > frame_right:
		target.global_position.x = frame_right
	if tpos.z > frame_top:
		target.global_position.z = frame_top
	elif tpos.z < frame_bottom:
		target.global_position.z = frame_bottom

	# Draw frame boundary if enabled
	if draw_camera_logic:
		draw_logic()

	super(delta)

func draw_logic() -> void:
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()

	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF

	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)

	# Framing the corners
	var left: float = -box_width / 2
	var right: float = box_width / 2
	var top: float = -box_height / 2
	var bottom: float = box_height / 2

	# Draw frame border
	immediate_mesh.surface_add_vertex(Vector3(right, 0, top))
	immediate_mesh.surface_add_vertex(Vector3(right, 0, bottom))
	immediate_mesh.surface_add_vertex(Vector3(right, 0, bottom))
	immediate_mesh.surface_add_vertex(Vector3(left, 0, bottom))
	immediate_mesh.surface_add_vertex(Vector3(left, 0, bottom))
	immediate_mesh.surface_add_vertex(Vector3(left, 0, top))
	immediate_mesh.surface_add_vertex(Vector3(left, 0, top))
	immediate_mesh.surface_add_vertex(Vector3(right, 0, top))

	immediate_mesh.surface_end()

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.BLACK

	add_child(mesh_instance)
	mesh_instance.global_transform = Transform3D.IDENTITY
	mesh_instance.global_position = Vector3(global_position.x, target.global_position.y, global_position.z)

	# Free the mesh after one frame update
	await get_tree().process_frame
	mesh_instance.queue_free()
