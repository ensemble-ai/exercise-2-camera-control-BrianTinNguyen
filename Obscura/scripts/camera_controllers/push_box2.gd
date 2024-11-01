class_name PushBox2
extends CameraControllerBase

@export var top_left: Vector2         
@export var bottom_right: Vector2     
@export var autoscroll_speed: Vector3 
@export var box_width: float = 10.0
@export var box_height: float = 10.0

func _ready() -> void:
	super()
	position = target.position

func _process(delta: float) -> void:
	if !current:
		return

	# Autoscroll frame on the x and z axes
	global_position.x += autoscroll_speed.x * delta
	global_position.z += autoscroll_speed.z * delta

	var tpos = target.global_position
	var cpos = global_position

	# Frame boundary edges
	var frame_left = cpos.x + top_left.x
	var frame_right = cpos.x + bottom_right.x
	var frame_top = cpos.z + top_left.y
	var frame_bottom = cpos.z + bottom_right.y

	# Boundary checks for left
	if tpos.x < frame_left:
		target.global_position.x = frame_left
	if tpos.x > frame_right:
		target.global_position.x = frame_right
	if tpos.z > frame_top:
		target.global_position.z = frame_top
	if tpos.z < frame_bottom:
		target.global_position.z = frame_bottom

	if draw_camera_logic:
		draw_logic()

	super(delta)

func draw_logic() -> void:
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()

	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF

	var left: float = top_left.x
	var right: float = bottom_right.x
	var top: float = top_left.y
	var bottom: float = bottom_right.y

	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)

	# Draw the frame border in 3D space
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
